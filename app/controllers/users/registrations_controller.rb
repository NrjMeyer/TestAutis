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
        generate_pdf(@payment, "paypal", Digest::SHA1.hexdigest("p" + @payment.id.to_s)[0..7])
        render 'users/confirmations/confirm'
      end

    elsif params[:payment_option] == 'slimpay'
      @payment = SlimpayPayment.where(payment_reference: params[:reference]).last
      @user = User.find(@payment.user_id)

      payment = JSON.parse(validePaymentSlimpay(@payment, @user))

      puts payment

      if payment['executionStatus'] == 'toprocess'
        generate_pdf(@payment, "slimpay", Digest::SHA1.hexdigest("s" + @payment.id.to_s)[0..7])
        render 'users/confirmations/confirm'
      else
        redirect_to root_path
      end

    elsif params[:payment_option] == 'cheque'

      @payment = PaymentCheque.where(user_id: params[:id])
      @user = User.find(params[:id])

      generate_pdf(@payment, "cheque", Digest::SHA1.hexdigest("c" + @payment.id.to_s)[0..7])
      render 'user/confirmations/confirm'
    end
  end

  def generate_pdf(payment, method, id)
    receipt_id = id
    amount = payment.amount
    payment_method = method
    adress = payment.user.address + payment.user.address_extend + payment.user.post_code.to_s + payment.user.city
    name = payment.user.name
    date = payment.created_at

    @id = id
    @pdf = WickedPdf.new.pdf_from_string(
      render_to_string("recu/index.html.erb", :locals => {
        :receipt_id => receipt_id,
        :amount => amount,
        :payment_method => payment_method,
        :adress => adress,
        :date => date,
        :name => name })
    )
    @filename ||= "#{Rails.root}/public/pdfs/#{id}.pdf"
    @save_path ||= Rails.root.join('public/pdfs', id + '.pdf')
    @access_path ||= "pdfs/#{id}.pdf"

    File.open(@save_path, 'wb') do |file|
      file << @pdf
    end
  end

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

    @user.save
    @slimpay_payment.user_id = @user.id
    @slimpay_payment.save

    side_users = SideUser.where(cache_user_id: @cache_user.id)

    side_users.each do |side_user|
      side_user.user_id = @user.id
    end

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

    @user.save
    @paypal_payment.user_id = @user.id
    @paypal_payment.save

    side_users = SideUser.where(cache_user_id: @cache_user.id)

    side_users.each do |side_user|
      side_user.user_id = @user.id
    end

    return @user
  end

end
