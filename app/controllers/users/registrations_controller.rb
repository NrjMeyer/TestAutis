class Users::RegistrationsController < Devise::RegistrationsController
  include Encrypt
  include Paypal
  include Slimpay
  include Cb

  before_action :configure_sign_up_params, only: [:create]
# before_action :configure_account_update_params, only: [:update]
  # GET /resource/sign_up
  class UserLike
    attr_accessor :name, :surname, :email
    def initialize(name, surname, email)
      @name     = name
      @surname   = surname
      @email = email
    end
  end

  def auto_response
    Cb.autoresponse(params[:DATA])
    redirect_to root_path
  end

  def new_cb
    result = Cb.response(params[:DATA])
    if session[:type] == "don"
      @type_don = true

      @don = Don.find(session[:don_id])
      @user = UserLike.new(@don.donor_name, @don.donor_surname, @don.donor_mail)

      @payment = valid_don_cb(result, @don)
      @rounds = MoneyDivision.all
      generate_pdf(@payment, "carte", true)

      ConfirmMailer.success_subscription(@user, @url_path, @don.fiscal_mail, true).deliver_now
      session[:type] = nil
      render "users/confirmations/confirm"

    elsif session[:type] == "adhesion"
      @type_don = false

      @user = createUserCard(result, session[:id])
      session[:type] = nil

      if @user.save
        CacheUser.where(email: @user.email).destroy_all
        render 'users/registrations/new'
      else
        render 'cache_users/error'
      end
    else
      redirect_to root_path
    end

  end

  def new_paypal
    if cookies.signed.encrypted[:type] == "don"
      @type_don = true

      @don = Don.find(cookies.signed.encrypted[:don_id])
      @user = UserLike.new(@don.donor_name, @don.donor_surname, @don.donor_mail)

      if @don.recurring == false
        @payment = valid_don_paypal(params, @don)
      else
        @payment = valid_don_paypal(params, @don, true)
      end

      cookies.delete :type
      cookies.delete :don_id
      @rounds = MoneyDivision.all
      generate_pdf(@payment, "paypal", true)

      ConfirmMailer.success_subscription(@user, @url_path, @don.fiscal_mail, true).deliver_now

      render "users/confirmations/confirm"

    elsif cookies.signed.encrypted[:type] == "adhesion"
      @type_don = false

      if CacheUser.find_by(payment_id: params[:token]) != nil
        @user = createUserPaypal(params, true) or return

        if @user.save
          CacheUser.where(email: @user.email).destroy_all
          render 'users/registrations/new'
        else
          puts @user.errors.inspect
          render 'cache_users/error'
        end
      else
        @user = createUserPaypal(params) or return

        if @user.save
          CacheUser.where(email: @user.email).destroy_all
          render 'users/registrations/new'
        else
          puts @user.errors.inspect
          render 'cache_users/error'
        end
      end
    end
  end

  def new_slimpay
    if cookies.signed.encrypted[:type] == "don"
      @type_don = true

      @don = Don.find(cookies.signed.encrypted[:don_id])
      @user = UserLike.new(@don.donor_name, @don.donor_surname, @don.donor_mail)

      if @don.recurring == false
        validePaymentSlimpay(@don.amount, @don.donor_mail)
      end

      @don.validated = true
      @don.save

      @payment = @don.slimpay_payment

      cookies.delete :type
      cookies.delete :don_id
      @rounds = MoneyDivision.all
      generate_pdf(@payment, "paypal", true)

      ConfirmMailer.success_subscription(@user, @url_path, @don.fiscal_mail, true).deliver_now

      render "users/confirmations/confirm"

    elsif cookies.signed.encrypted[:type] == "adhesion"
      @type_don = false

      @user = createUserSlimpay(cookies.signed.encrypted[:id]) or return

      if @user.save
        cookies.delete :id
        cookies.delete :type
        CacheUser.where(email: @user.email).destroy_all
        render 'users/registrations/new'
      else
        puts @user.errors.inspect
        cookies.delete :type
        render 'cache_users/error'
      end
    else
      redirect_to root_path
    end
  end

  def new_cheque
    if cookies.signed.encrypted[:type] == "don"
      @type_don = true

      @don = Don.find(cookies.signed.encrypted[:don_id])
      @user = UserLike.new(@don.donor_name, @don.donor_surname, @don.donor_mail)

      @payment = ChequePayment.find(@don.cheque_payment_id)
      valid_don_cheque(@don)
      @payment_option = 'cheque'
      cookies.delete :type
      cookies.delete :don_id
      @rounds = MoneyDivision.all

      ConfirmMailer.success_subscription(@user, nil, false, true).deliver_now

      render "users/confirmations/confirm"

    elsif cookies.signed.encrypted[:type] == "adhesion"
      @type_don = false

      @user = createUserCheque(params[:payment_key]) or return

      if @user.save
        CacheUser.where(email: @user.email).destroy_all
        cookies.delete :type
        render 'users/registrations/new'
      else
        cookies.delete :type
        puts @user.errors.inspect
        render 'cache_users/error'
      end
    else
      redirect_to root_path
    end

  end

  def payment

    if cookies.signed.encrypted[:user_id]
      @user = User.find(cookies.signed.encrypted[:user_id])
      cookies.delete :user_id
    elsif session[:id] != nil
      @user = User.find(session[:id])
      session[:id] = nil
    elsif current_user
      @user = current_user
    else
      redirect_to root_path
    end

    if @user

      if @user.payment_option == 'paypal'

        if @user.monthly_payment == true
          @payment = PaypalPayment.where(token: @user.paypal_payments.last.token).last

          payment = validePaymentPaypal(@payment, true)
        else
          @payment = PaypalPayment.where(payment: @user.paypal_payments.last.payment).last

          payment = validePaymentPaypal(@payment)
        end

        if payment['state'] == 'approved' || payment['state'] == 'Active'
          ConfirmMailer.success_subscription(@user).deliver_now
          generate_pdf(@payment, "paypal")
          render 'users/confirmations/confirm'
        else
          redirect_to root_path
        end

      elsif @user.payment_option == 'slimpay'
        @payment = SlimpayPayment.where(payment_reference: @user.slimpay_payments.last.payment_reference).last

        if @user.monthly_payment == false
          payment = JSON.parse(validePaymentSlimpay(@payment.amount, @user.email))
        end
        ConfirmMailer.success_subscription(@user).deliver_now
        generate_pdf(@payment, "paypal")
        render 'users/confirmations/confirm'

      elsif @user.payment_option == 'cheque'
        @payment_option = 'cheque'

        @payment = ChequePayment.where(user_id: @user.id).last
        ConfirmMailer.success_subscription(@user).deliver_now
        render 'users/confirmations/confirm'
      elsif @user.payment_option == "card"

        @payment = CardPayment.where(user_id: @user.id).last
        ConfirmMailer.success_subscription(@user).deliver_now
        generate_pdf(@payment, "carte")
        render 'users/confirmations/confirm'
      end
    end
  end

  def generate_pdf(payment, method, don = false)
    receipt_id = method + payment.id.to_s + "/" + Time.current.year.to_s
    amount = payment.reduction
    payment_method = method
    if don == true
      adress = payment.dons.last.donor_adress
      name = payment.dons.last.donor_name + " " + payment.dons.last.donor_surname
    else
      adress = payment.user.address + " " + payment.user.address_extend + " " + payment.user.post_code.to_s + " " + payment.user.city
      name = payment.user.name + " " + payment.user.surname
    end
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
    @filename ||= "#{Rails.root}/public/pdfs/#{payment.hash}.pdf"
    @save_path ||= Rails.root.join('public/pdfs', payment.hash.to_s + '.pdf')
    @access_path ||= "pdfs/#{payment.hash}.pdf"
    @url_path ||= Settings.base.url+"/"+@access_path

    File.open(@save_path, 'wb') do |file|
      file << @pdf
    end
  end

  def validePaymentSlimpay(amount, email)
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
              reference: email
          },
          reference: nil,
          amount: amount,
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
          :payer_id => payment.payer
        }.to_json
      )
    end
  end

  def createUserCard(param, session_id)
    @cache_user = CacheUser.find(session_id)

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
      payment_option: 'card',
    )

    if @cache_user.dons
      @user.dons << @cache_user.dons
      @user.dons.map{ |d| d.validated = true}
    end

    # Le montant du payement passé à l'api est sans virgule, on divise donc par 100
    # => 4000 de l'api ==> 4000 / 100 = 40
    converted_amount = param[5].to_i / 100

    payment = CardPayment.create(user_id: @user.id, amount: converted_amount, payment_reference: param[6])

    @user.save

    side_users = SideUser.where(cache_user_id: @cache_user.id)

    side_users.each do |side_user|
      side_user.user_id = @user.id
      side_user.save
    end

    return @user
  end

  def createUserCheque(key)
    @cache_user = CacheUser.find_by(payment_id: key)

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
      payment_option: 'cheque',
    )

    if @cache_user.dons
      @user.dons << @cache_user.dons
      @user.dons.map{ |d| d.validated = true}
    end

    @user.cheque_payments << @cache_user.cheque_payment
    @user.save

    side_users = SideUser.where(cache_user_id: @cache_user.id)

    side_users.each do |side_user|
      side_user.user_id = @user.id
      side_user.save
    end

    return @user
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
      @user.dons.map{ |d| d.validated = true}
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
      @user.dons.map{ |d| d.validated = true}
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

  def valid_don_paypal(params, don, reccuring = false)

    if reccuring == false

      paypal_payment = PaypalPayment.create(
        payment: params[:paymentId],
        payer: params[:PayerID],
        token: params[:token],
        amount: don.amount,
      )

    else

      paypal_payment = PaypalPayment.create(
        token: params[:token],
        amount: don.amount,
      )

    end

    payment = validePaymentPaypal(paypal_payment, reccuring)

    if payment['state'] == 'approved' || payment['state'] == 'Active'
      don.validated = true
      don.paypal_payment_id = paypal_payment.id
      if don.save
        return paypal_payment
      end
    elsif payment["name"] == "PAYMENT_ALREADY_DONE"
      redirect_to root_path
    else
      redirect_to root_path
    end
  end

  def valid_don_cheque(don)
    don.validated = true
    don.save
  end

  def valid_don_cb(param, don)

    converted_amount = param[5].to_i / 100

    payment = CardPayment.create(
      amount: converted_amount,
      payment_reference: param[6]
    )

    don.card_payment_id = payment.id
    don.amount = converted_amount
    don.validated = true
    don.save

    return payment
  end

  def user_already_exist(email)
    user = User.where(email: email).last
    if user != nil
      return true
    else
      return false
    end
  end

end
