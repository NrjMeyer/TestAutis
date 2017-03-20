class Users::RegistrationsController < Devise::RegistrationsController
  include Encrypt
  include Paypal
  include Slimpay

  before_action :configure_sign_up_params, only: [:create]
# before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up

  def new
    if CacheUser.find_by(payment_id: params[:paymentId]) != nil

      @user = createUserPaypal(params)

      if @user.save
        CacheUser.where(email: @cache_user.email).destroy_all
      else
        puts @user.errors.inspect
      end

    elsif CacheUser.find_by(payment_id: params[:token]) != nil
      
      @user = createUserPaypal(params, true)

      if @user.save
        CacheUser.where(email: @cache_user.email).destroy_all
      else
        puts @user.errors.inspect
      end


    elsif cookies.signed.encrypted[:id] != nil

      @user = createUserSlimpay(cookies.signed.encrypted[:id])

      if @user.save
        cookies.delete :id
        CacheUser.where(email: @cache_user.email).destroy_all
      else
        puts @user.errors.inspect
      end

    end
  end

  def payment
    if params[:payment_option] == 'paypal'

      if params[:monthly_payment] == 'true'
        @payment = PaypalPayment.where(token: params[:payment_token]).last
        puts @payment.inspect
        @user = User.find(@payment.user_id)

        payment = validePaymentPaypal(@payment, true)
        puts payment
      else
        @payment = PaypalPayment.where(payment: params[:payment_id]).last
        @user = User.find(@payment.user_id)

        payment = validePaymentPaypal(@payment)
      end

      
      if payment['state'] == 'approved' || payment['state'] == 'Active'
        render 'users/confirmations/confirm'
      end
      
    elsif params[:payment_option] == 'slimpay'

      @payment = SlimpayPayment.where(payment_reference: params[:reference]).last
      @user = User.find(@payment.user_id)
      
      payment = JSON.parse(validePaymentSlimpay(@payment, @user))
      
      puts payment

      if payment['executionStatus'] == 'toprocess'
        render 'users/confirmations/confirm'
      else
        redirect_to root_path
      end
    
    elsif params[:payment_option] == 'cheque'

      @payment = PaymentCheque.where(user_id: params[:id])
      @user = User.find(params[:id])
      
      render 'user/confirmations/confirm'
    end
  
  end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :surname,
  #     :phone_number, :address, :address_extend, :post_code, :city, :payment_id])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   redirect_to new_user_session_path
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end

  def validePaymentSlimpay(payment, user)
    payment = HTTParty.post("https://api-sandbox.slimpay.net/payments/in",
      headers: {
        'Accept' => 'application/hal+json; profile="https://api.slimpay.net/alps/v1"',
        'Content-Type' => 'application/json',
        'Authorization' => 'Bearer ' + Slimpay.get_token,
      },
      body: {
          creditor: {
              reference: Settings.slimpay.creditor_reference
          },
          subscriber: {
              reference: user.email
          },
          reference: nil,
          amount: payment.amount,
          currency: 'EUR',
          scheme: 'SEPA.DIRECT_DEBIT.CORE',
          label: 'Débit pour votre adhésion vaincre l\'autisme',
          executionDate: nil,
      }.to_json
    )
  end

  def validePaymentPaypal(payment, reccuring = false)
    if reccuring == true
      HTTParty.post('https://api.sandbox.paypal.com/v1/payments/billing-agreements/'+payment.token+'/agreement-execute',
        headers: {
          'Content-Type' => 'application/json',
          'Authorization' => 'Bearer ' + Paypal.get_token,
        }
      )
    else
      HTTParty.post("https://api.sandbox.paypal.com/v1/payments/payment/"+payment.payment+"/execute",
        headers: {
          'Content-Type' => 'application/json',
          'Authorization' => 'Bearer ' + Paypal.get_token,
        },
        body: {
          :payer_id => params[:payer_id]
        }.to_json
      )
    end
  end

  def createUserSlimpay(cookie_id)
    @cache_user = CacheUser.find_by(payment_id: cookie_id)
      
      password = Encrypt.decryption(@cache_user.password)
      @user = User.create(
        email: @cache_user.email,
        password: password,
        name: @cache_user.name,
        surname: @cache_user.surname,
        phone_number: @cache_user.phone_number,
        address: @cache_user.address,
        address_extend: @cache_user.address_extend,
        post_code: @cache_user.post_code,
        city: @cache_user.city,
        tax_receipt: @cache_user.tax_receipt,
        sub_newsletter: @cache_user.sub_newsletter,
        payment_option: 'slimpay'
      )

      @cache_user.slimpay_payment.user_id = @user.id
      @cache_user.save
      return @user
  end

  def createUserPaypal(params, reccuring = false)

    if reccuring == false

      @cache_user = CacheUser.find_by(payment_id: params[:paymentId])

      @paypal_payment = PaypalPayment.create(
        payment: params[:paymentId],
        payer: params[:PayerID],
        token: params[:token],
      )
    
    else

      @cache_user = CacheUser.find_by(payment_id: params[:token])

      @paypal_payment = PaypalPayment.create(
        token: params[:token],
      )
  
    end

    password = Encrypt.decryption(@cache_user.password)
    @user = User.create(
      email: @cache_user.email,
      password: password,
      name: @cache_user.name,
      surname: @cache_user.surname,
      phone_number: @cache_user.phone_number,
      address: @cache_user.address,
      address_extend: @cache_user.address_extend,
      post_code: @cache_user.post_code,
      city: @cache_user.city,
      tax_receipt: @cache_user.tax_receipt,
      sub_newsletter: @cache_user.sub_newsletter,
      monthly_payment: reccuring,
      payment_option: 'paypal'
    )

    @user.paypal_payment = @paypal_payment

    return @user
  end

end
