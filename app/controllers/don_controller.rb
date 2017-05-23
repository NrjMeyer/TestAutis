class DonController < ApplicationController
  include Paypal
  include Slimpay
  include Cb

  def new
  end

  def create
    if !monthly
      if payment_option == "paypal"
        token = Paypal.get_token
        payment_data = Paypal.simplePayment(token, amount)

        redirect_to payment_data['links'][1]['href']
      elsif payment_option == "debit"
        token = Slimpay.get_token
        payment_data = Slimpay.simpleIbanPayment(token, amount, mail)
        
        cookies.signed.encrypted[:id] = payment_json['reference']
        redirect_to payment_json['_links']['https://api.slimpay.net/alps#user-approval']['href']
      elsif payment_option == "cheque"
        
        redirect_to validation_path(payment_key: payment_key)
      elsif payment_option == "card"
        cookies.signed.encrypted[:id] = @user.id
        cookies.signed.encrypted[:amount] = total_payment_amount.to_s + "00"
        redirect_to '/cb'
      end
    else
      if payment_option == "paypal"
        token = Paypal.get_token
        payment_data = Paypal.reccurringPayment(token, total_payment_amount, @user)
        token = payment_data['links'][0]['href'].scan(/token=(.*)/)[0][0]

        redirect_to payment_data['links'][0]['href']
      elsif payment_option == "debit"
        token = Slimpay.get_token 
        payment_data = Slimpay.recurringIbanPayment(token, total_payment_amount, @user.email)
        payment_json = JSON.parse(payment_data)
        slimpay_payment = SlimpayPayment.create(
          payment_reference: payment_json['reference'],
          amount: total_payment_amount
        )

        cookies.signed.encrypted[:id] = payment_json['reference']
        redirect_to payment_json['_links']['https://api.slimpay.net/alps#user-approval']['href']
      end
    end
  end

end
