class CacheUsersController < ApplicationController
  include Paypal
  include Slimpay
  include Encrypt

  def new
    @offers = Offer.all
    @roles = Role.all

    render 'cache_users/new'
  end

  def create

    @user = CacheUser.new(params.require(:cache_user).permit(:password,
      :password_confirmation, :name, :surname, :phone_number, :address,
      :address_extend, :post_code, :city, :email))

    @user.password = Encrypt.encryption(params.require(:cache_user).require(:password))
    @user.password_confirmation = Encrypt.encryption(params.require(:cache_user).require(:password_confirmation))

    offer = Offer.find(params[:formule])
    @user.offer_id = offer.id

    payment_option = params[:payment_option]
    monthly = ActiveRecord::Type::Boolean.new.cast(params[:monthly])
    puts monthly

    if !monthly
      if payment_option == "paypal"
        token = Paypal.get_token
        payment_data = Paypal.simplePayment(token, offer.amount)
        @user.payment_id = payment_data['id']
      elsif payment_option == "debit"
        token = Slimpay.get_token
        payment_data = Slimpay.simpleIbanPayment(token, offer.amount, @user.email)
        payment_json = JSON.parse(payment_data)
        @user.payment_id = payment_json['reference']
        slimpay_payment = SlimpayPayment.create(
          payment_reference: payment_json['reference'],
          amount: offer.amount
        )
        @user.slimpay_payment = slimpay_payment
      elsif payment_option == 'card'
        token = Slimpay.get_token
        payment_data = Slimpay.simpleCardPayment(token, offer.amount, @user.email)
        payment_json = JSON.parse(payment_data)
        slimpay_payment = SlimpayPayment.create(
          payment_reference: payment_json['reference'],
          amount: offer.amount
        )
        @user.payment_id = payment_json['reference']
      elsif payment_option == 'cheque'
        @user = User.new(params.require(:cache_user).permit(:password,
      :password_confirmation, :name, :surname, :phone_number, :address,
      :address_extend, :post_code, :city, :email))

        @user.payment_option = 'cheque'

        @cheque = PaymentCheque.create(amount: offer.amount, validated: false, user_id: @user.id)

        if @user.save
          redirect_to validation_path
        end
      end
    else
      if payment_option == 'debit'
        token = Slimpay.get_token
        payment_data = Slimpay.recurringIbanPayment(token, offer.amount, @user.email)
        payment_json = JSON.parse(payment_data)
        slimpay_payment = SlimpayPayment.create(
          payment_reference: payment_json['reference'],
          amount: offer.amount
        )
        @user.payment_id = payment_json['reference']
      elsif payment_option == 'paypal'
        token = Paypal.get_token
        payment_data = Paypal.reccurringPayment(token, offer.amount)
        token = payment_data['links'][0]['href'].scan(/token=(.*)/)[0][0]
        @user.payment_id = token
      end
    end

    if @user.save
      if payment_option == 'paypal'
        if !monthly
          redirect_to payment_data['links'][1]['href']
        else
          redirect_to payment_data['links'][0]['href']
        end
      elsif payment_option == 'debit' || payment_option == 'card'
        cookies.signed.encrypted[:id] = payment_json['reference']
        redirect_to payment_json['_links']['https://api.slimpay.net/alps#user-approval']['href']
      end  
    else
      puts @user.errors.inspect
    end
  end
end
