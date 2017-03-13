class CacheUsersController < ApplicationController
  include Paypal
  include Slimpay
  include Encrypt

  def new
    render 'cache_users/new'
  end

  def create
    @user = CacheUser.new(params.require(:cache_user).permit(:password,
      :password_confirmation, :name, :surname, :phone_number, :address,
      :address_extend, :post_code, :city, :email))

    @user.password = Encrypt.encryption(params.require(:cache_user).require(:password))
    @user.password_confirmation = Encrypt.encryption(params.require(:cache_user).require(:password_confirmation))

    payment_option = params[:payment_option]
    monthly = false

    if payment_option == "paypal" && monthly == false
      token = Paypal.get_token
      payment_data = Paypal.simplePayment(token, 20)
      @user.payment_id = payment_data['id']
    elsif payment_option == "debit" && monthly == false
      token = Slimpay.get_token
      payment_data = Slimpay.simpleIbanPayment(token, 20)
      payment_json = JSON.parse(payment_data)
      @user.payment_id = payment_json['reference']
      slimpay_payment = SlimpayPayment.create(
        payment_reference: payment_json['reference'],
        amount: 20
      )
      @user.slimpay_payment = slimpay_payment
    else
      puts 'meh'
    end

    if @user.save
      if payment_option == 'paypal'
        redirect_to payment_data['links'][1]['href']
      elsif payment_option == 'debit'
        cookies.signed.encrypted[:id] = payment_json['reference']
        redirect_to payment_json['_links']['https://api.slimpay.net/alps#user-approval']['href']
      end  
    else
      puts @user.errors.inspect
    end
  end
end
