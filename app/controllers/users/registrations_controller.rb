class Users::RegistrationsController < Devise::RegistrationsController
  include Encrypt
  include Paypal
  include Slimpay

  before_action :configure_sign_up_params, only: [:create]
# before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up

  def new
    # Use Paypal
    if params.has_key?(:paymentId)

      @user = createUserPaypal(params) or return

      if @user.save
        CacheUser.where(email: @cache_user.email).destroy_all
      else
        puts @user.errors.inspect
      end

    elsif CacheUser.find_by(payment_id: params[:token]) != nil

      @user = createUserPaypal(params, true) or return

      if @user.save
        CacheUser.where(email: @cache_user.email).destroy_all
      else
        puts @user.errors.inspect
      end

    # Use Slimpay
    elsif cookies.signed.encrypted[:id] != nil

      @user = createUserSlimpay(cookies.signed.encrypted[:id]) or return

      if @user.save
        cookies.delete :id
        CacheUser.where(email: @cache_user.email).destroy_all
      else
        puts @user.errors.inspect
      end

    end
  end

  def payment

    if cookies.signed.encrypted[:user_id]
      @user = User.find(cookies.signed.encrypted[:user_id])
      cookies.delete :user_id
    elsif current_user
      @user = current_user
    else
      redirect_to root_path
    end

    if @user

        if @user.payment_option == 'paypal'

        if @user.monthly_payment == true
          @payment = PaypalPayment.where(token: @user.paypal_payments.last.token).last
          puts @payment.inspect

          payment = validePaymentPaypal(@payment, true)
          puts payment
        else
          @payment = PaypalPayment.where(payment: @user.paypal_payments.last.payment).last

          payment = validePaymentPaypal(@payment)
        end


        if payment['state'] == 'approved' || payment['state'] == 'Active'
          generate_pdf(@payment, "paypal")
          render 'users/confirmations/confirm'
        else
          redirect_to root_path
        end

      elsif @user.payment_option == 'slimpay'
          @payment = SlimpayPayment.where(payment_reference: @user.slimpay_payments.last.payment_reference).last

        if @user.monthly_payment == false
          payment = JSON.parse(validePaymentSlimpay(@payment, @user))
          puts payment
        end

        generate_pdf(@payment, "paypal")
        render 'users/confirmations/confirm'

      elsif @user.payment_option == 'cheque'

        @payment = ChequePayment.where(user_id: @user.id).last
        generate_pdf(@payment, "cheque")
        render 'user/confirmations/confirm'
      end
    end
  end

  def generate_pdf(payment, method)
    receipt_id = "method" + payment.id.to_s + "/" + Time.current.year
    amount = payment.amount
    payment_method = method
    adress = payment.user.address + payment.user.address_extend + payment.user.post_code.to_s + payment.user.city
    name = payment.user.name
    date = payment.created_at

    @pdf = WickedPdf.new.pdf_from_string(
      render_to_string("recu/index.html.erb", :locals => {
        :receipt_id => receipt_id,
        :amount => amount,
        :payment_method => payment_method,
        :adress => adress,
        :date => date,
        :name => name })
    )
    @filename ||= "#{Rails.root}/public/pdfs/#{receipt_id}.pdf"
    @save_path ||= Rails.root.join('public/pdfs', receipt_id + '.pdf')
    @access_path ||= "pdfs/#{receipt_id}.pdf"

    File.open(@save_path, 'wb') do |file|
      file << @pdf
    end
  end

  def validePaymentSlimpay(payment, user)
    generate_pdf(payment, "slimpay", Digest::SHA1.hexdigest("s" + payment.id.to_s))

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

    puts payment.inspect
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
          :payer_id => payment.payer
        }.to_json
      )
    end
  end

  def createUserSlimpay(cookie_id)
    @cache_user = CacheUser.find_by(payment_id: cookie_id)

    if user_already_exist(@cache_user.email)
      CacheUser.where(email: @cache_user.email).destroy_all
      redirect_to erreur_path and return
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
      newsletter: @cache_user.newsletter,
      monthly_payment: @cache_user.monthly,
      payment_option: 'slimpay',
    )

    if @cache_user.dons
      @user.dons << @cache_user.dons
    end

    @user.save

    slimpay_payment = SlimpayPayment.where(cache_user_id: @cache_user.id).last
    slimpay_payment.user_id = @user.id
    slimpay_payment.save

    side_users = SideUser.where(cache_user_id: @cache_user.id)

    side_users.each do |side_user|
      side_user.user_id = @user.id
      side_user.save
    end

    return @user
  end

  def createUserPaypal(params, reccuring = false)

    if reccuring == false

      @cache_user = CacheUser.find_by(payment_id: params[:paymentId])

      if user_already_exist(@cache_user.email)
        CacheUser.where(email: @cache_user.email).destroy_all
        redirect_to erreur_path and return
      end

      @paypal_payment = PaypalPayment.create(
        payment: params[:paymentId],
        payer: params[:PayerID],
        token: params[:token],
        amount: @cache_user.payment_amount
      )

    else

      @cache_user = CacheUser.find_by(payment_id: params[:token])

      if user_already_exist(@cache_user.email)
        CacheUser.where(email: @cache_user.email).destroy_all
        redirect_to erreur_path and return
      end

      @paypal_payment = PaypalPayment.create(
        token: params[:token],
        amount: @cache_user.payment_amount
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
      newsletter: @cache_user.newsletter,
      monthly_payment: reccuring,
      payment_option: 'paypal',
    )

    if @cache_user.dons
      @user.dons << @cache_user.dons
    end

    @user.save
    @paypal_payment.user_id = @user.id
    @paypal_payment.save

    side_users = SideUser.where(cache_user_id: @cache_user.id)

    side_users.each do |side_user|
      side_user.user_id = @user.id
      side_user.save
    end

    return @user
  end

  def user_already_exist(email)
    user = User.where(email: email).last
    if user. != nil
      return true
    else
      return false
    end
  end

end
