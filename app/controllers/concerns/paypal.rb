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
            "return_url": "http://127.0.0.1:3000/validation",
            "cancel_url": "http://127.0.0.1:3000/anulation"
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

end
