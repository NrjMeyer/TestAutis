class DonController < ApplicationController
  include Paypal
  include Slimpay
  include Cb

  class UserLike
    attr_accessor :address, :address_extend, :post_code, :city, :full_addresse
    def initialize(address, address_extend, post_code, city, full_addresse)
      @address     = address
      @address_extend   = address_extend
      @post_code = post_code
      @city = city
      @full_addresse = full_addresse
    end
  end

  def new
    @offer_don = OfferDon.all
  end

  def create

    cookies.signed.encrypted[:type] = "don"

    if params[:formule_custom] != nil
      amount = params[:formule_custom].to_i
    else
      amount = OfferDon.find(params[:formule]).amount
    end

    mail = params[:don][:email]
    user = UserLike.new(
      params[:don][:address], 
      params[:don][:address_extend], 
      params[:don][:post_code], 
      params[:don][:city],
      params[:don][:address] +" "+ params[:don][:address_extend] +" "+ params[:don][:post_code] +" "+ params[:don][:city],
    )

    payment_option = params[:payment_option]
    monthly = ActiveRecord::Type::Boolean.new.cast(params[:monthly])

    if params[:fiscal_mail] != nil
      fiscal_mail = true
    else
      fiscal_mail = false
    end

    don = Don.create(
      amount: amount,
      donor_name: params[:don][:surname],
      donor_surname: params[:don][:name],
      donor_adress: user.full_addresse,
      donor_mail: mail,
      donor_phone: params[:don][:phone_number],
      fiscal_mail: fiscal_mail,
    )

    if !monthly

      don.recurring = false
      don.save
      
      if payment_option == "paypal"
        token = Paypal.get_token
        payment_data = Paypal.simplePayment(token, amount)

        cookies.signed.encrypted[:don_id] = don.id
        redirect_to payment_data['links'][1]['href']
      elsif payment_option == "debit"
        token = Slimpay.get_token
        payment_data = Slimpay.simpleIbanPayment(token, amount, mail)
        payment_json = JSON.parse(payment_data)
        slimpay_payment = SlimpayPayment.create(
          payment_reference: payment_json['reference'],
          amount: amount,
        )

        don.slimpay_payment_id = slimpay_payment.id
        don.save

        cookies.signed.encrypted[:don_id] = don.id
        redirect_to payment_json['_links']['https://api.slimpay.net/alps#user-approval']['href']
      elsif payment_option == "cheque"
        
        cookies.signed.encrypted[:don_id] = don.id
        redirect_to cheque_validation_path(payment_key: payment_key)
      elsif payment_option == "card"
        
        don.amount = amount.to_s + "00"
        don.save

        cookies.signed.encrypted[:don_id] = don.id
        redirect_to '/cb'
      end
    else

      don.recurring = true
      don.save

      if payment_option == "paypal"
        token = Paypal.get_token
        payment_data = Paypal.reccurringPayment(token, amount, user, true)
        token = payment_data['links'][0]['href'].scan(/token=(.*)/)[0][0]

        cookies.signed.encrypted[:don_id] = don.id
        redirect_to payment_data['links'][0]['href']
      elsif payment_option == "debit"
        token = Slimpay.get_token 
        payment_data = Slimpay.recurringIbanPayment(token, amount, mail)
        payment_json = JSON.parse(payment_data)
        slimpay_payment = SlimpayPayment.create(
          payment_reference: payment_json['reference'],
          amount: amount
        )

        don.slimpay_payment_id = slimpay_payment.id
        don.save

        cookies.signed.encrypted[:don_id] = don.id
        redirect_to payment_json['_links']['https://api.slimpay.net/alps#user-approval']['href']
      end

    end

  end

end
