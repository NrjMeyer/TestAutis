class CacheUsersController < ApplicationController
  include Paypal
  include Slimpay
  include Encrypt

  def new
    @offers = Offer.all
    @roles = Role.all
    @cache_user = CacheUser.new

    render 'cache_users/new'
  end

  def create
    # Creating cache user
    @user = CacheUser.new(params.require(:cache_user).permit(:password,
      :password_confirmation, :name, :surname, :phone_number, :address,
      :address_extend, :post_code, :city, :email, :newsletter))

    @user.password = Encrypt.encryption(params.require(:cache_user).require(:password))
    @user.password_confirmation = Encrypt.encryption(params.require(:cache_user).require(:password_confirmation))


    # Link selected formule to cache user
    offer = Offer.find(params[:formule])
    @user.offer_id = offer.id

    # Amount of side_users
    side_user_amount = 0

    # Parsing family members and link them to cache user
    if params[:family_members] != ""
      side_users = JSON.parse(params[:family_members])
      # Adding 12 per side_user to total amount
      side_users.each do |side_user|
        side_user_amount = side_user_amount + 12
      end
    end

    # Find if payment is monthly and which one to use
    payment_option = params[:payment_option]
    monthly = ActiveRecord::Type::Boolean.new.cast(params[:monthly])
    @user.monthly = monthly

    # Create total amount of the payment from offer price and number of side users
    total_payment_amount = offer.amount + side_user_amount

    # Get donation and add it to total amount
    don = params.require(:cache_user).permit(dons: :amount)

    # Add donation to total price if exist
    if don[:dons][:amount] != ""
      @user.dons << Don.create(amount: don[:dons][:amount])
      total_payment_amount = total_payment_amount + don[:dons][:amount].to_i
    end

    # Create payment, link it with the cache user and make api call
    if !monthly
      if payment_option == "paypal"
        token = Paypal.get_token
        payment_data = Paypal.simplePayment(token, total_payment_amount)
        @user.payment_id = payment_data['id']
        @user.payment_amount = total_payment_amount
      elsif payment_option == "debit"
        token = Slimpay.get_token
        payment_data = Slimpay.simpleIbanPayment(token, total_payment_amount, @user.email)
        payment_json = JSON.parse(payment_data)
        @user.payment_id = payment_json['reference']
        slimpay_payment = SlimpayPayment.create(
          payment_reference: payment_json['reference'],
          amount: total_payment_amount,
          cache_user_id: @user.id
        )
        @user.slimpay_payment = slimpay_payment
      elsif payment_option == 'card'
        token = Slimpay.get_token
        payment_data = Slimpay.simpleCardPayment(token, total_payment_amount, @user.email)
        payment_json = JSON.parse(payment_data)
        slimpay_payment = SlimpayPayment.create(
          payment_reference: payment_json['reference'],
          amount: total_payment_amount
        )
        @user.payment_id = payment_json['reference']
      elsif payment_option == 'cheque'
        @user = User.new(params.require(:cache_user).permit(:password,
      :password_confirmation, :name, :surname, :phone_number, :address,
      :address_extend, :post_code, :city, :email))

        @user.payment_option = 'cheque'

        @cheque = PaymentCheque.create(amount: total_payment_amount, validated: false, user_id: @user.id)

        if @user.save
          redirect_to validation_path
        end
      end
    else
      if payment_option == 'debit'
        token = Slimpay.get_token
        payment_data = Slimpay.recurringIbanPayment(token, total_payment_amount, @user.email)
        payment_json = JSON.parse(payment_data)
        slimpay_payment = SlimpayPayment.create(
          payment_reference: payment_json['reference'],
          amount: total_payment_amount
        )
        @user.slimpay_payment = slimpay_payment
        @user.payment_id = payment_json['reference']
      elsif payment_option == 'paypal'
        token = Paypal.get_token
        payment_data = Paypal.reccurringPayment(token, total_payment_amount)
        token = payment_data['links'][0]['href'].scan(/token=(.*)/)[0][0]
        @user.payment_id = token
        @user.payment_amount = total_payment_amount
      end
    end

    # If user saved, redirect to payment validation
    if @user.save

      # Saving side user
      if side_users
        side_users['members'].each do |member|
          SideUser.create(name: member['name'], email: member['mail'], cache_user_id: @user.id)
        end
      end
      
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
    # If user not saved, display errors
    else
      puts @user.errors.inspect
    end
  end
end
