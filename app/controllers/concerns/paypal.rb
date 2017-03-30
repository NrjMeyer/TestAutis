module Paypal
  extend ActiveSupport::Concern

  private
  def self.get_token
    HTTParty.post(Settings.paypal.server + Settings.paypal.url.get_token,
      headers: {
        'Accept' => 'application/json',
        'Accept-Language' => 'fr_FR',
        'Content-Type' => 'application/x-www-form-urlencoded',
        'Authorization' => 'Basic ' + Settings.paypal.key
      },
      body: {
        'grant_type' => 'client_credentials'
      }
    )['access_token']
  end

  def self.simplePayment(token, amount)
    HTTParty.post('https://api.sandbox.paypal.com/v1/payments/payment',
      headers: {
        'Content-Type' => 'application/json',
        'Authorization' => 'Bearer ' + token,
        },
      body: {
        "intent": "sale",
        "redirect_urls": {
          "return_url": Settings.paypal.callback_url_success,
          "cancel_url": Settings.paypal.callback_url_failure
        },
        "payer": {
          "payment_method": "paypal"
        },
        "transactions": [{
          "amount": {
            "total": amount.to_s,
            "currency": "EUR"
          },
          "description": "Adhésion à vaincre l'autisme pour un montant de " + amount.to_s + "€."
        }]
      }.to_json)
  end

  def self.reccurringPayment(token, amount, user)

    monthly_amount = amount / 12

    name = "Adhésion vaincre l\'autisme"
    description = "Payement de votre adhésion vraincre l\'autisme sur 12 mois pour "+amount.to_s+"€"

    response = HTTParty.post('https://api.sandbox.paypal.com/v1/payments/billing-plans/',
      headers: {
        'Content-Type' => 'application/json',
        'Authorization' => 'Bearer ' + token,
      },
      body: {
        "name": name,
        "description": description,
        "type": "fixed",
        "payment_definitions": [
        {
          "name": "Regular payment definition",
          "type": "REGULAR",
          "frequency": "MONTH",
          "frequency_interval": "1",
          "amount":
          {
            "value": monthly_amount,
            "currency": "EUR"
          },
          "cycles": "12",
        }],
        "merchant_preferences":
        {
          "return_url": Settings.paypal.callback_url_success,
          "cancel_url": Settings.paypal.callback_url_failure,
          "auto_bill_amount": "YES",
          "initial_fail_amount_action": "CONTINUE",
          "max_fail_attempts": "0"
        }
      }.to_json
    )
    puts response

    activate = HTTParty.patch(response['links'][0]['href'],
      headers: {
        'Content-Type' => 'application/json',
        'Authorization' => 'Bearer ' + token,
      },
      body:
          [{
            "op": "replace",
            "path": "/",
            "value": {
                "state": "ACTIVE"
            }
          }].to_json
    )

    HTTParty.post('https://api.sandbox.paypal.com/v1/payments/billing-agreements/',
      headers: {
        'Content-Type' => 'application/json',
        'Authorization' => 'Bearer ' + token,
      },
      body: {
        "name": name,
        "description": description,
        "start_date": DateTime.now + 14,
        "plan":
        {
          "id": response['id']
        },
        "payer":
        {
          "payment_method": "paypal"
        },
        "shipping_address":
        {
          "line1": @user.address,
          "line2": @user.address_extend,
          "city": @user.city,
          "postal_code": @user.post_code,
          "country_code": "FR",
        }
      }.to_json
    )
  end

end
