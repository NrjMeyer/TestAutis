class CacheUsersController < ApplicationController
  include Paypal
  include Encrypt

  def new
    render 'cache_users/new'
  end

  def create
    if params.require(:cache_user).require(:password) == params.require(:cache_user).require(:password_confirmation)
      @user = CacheUser.new(params.require(:cache_user).permit(:name, :surname,
        :phone_number, :address, :address_extend, :post_code, :city, :email))
      @user.password = Encrypt.encryption(params.require(:cache_user).require(:password))
    else
      raise 'Password non confirmé'
    end

    payment_option = params[:payment_option]
    monthly = false

    if payment_option == "paypal" && monthly == false
      token = Paypal.get_token
      payment_data = Paypal.simplePayment(token, 20)
      @user.payment_id = payment_data['id']
    end

    if @user.save
      puts payment_data
      redirect_to payment_data['links'][1]['href']
    else
      puts @user.errors.inspect
    end
  end
end
