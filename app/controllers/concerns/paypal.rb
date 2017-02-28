module Paypal
  extend ActiveSupport::Concern

  @@paypal_key = 'QVIyZzROSVBzZHpRUi1pZDUxS19hVWdsbnI5bHZDcDludHU0b1VNMTA5eHVDTUVzNTktNklKd3ZXVEtiQm9Qa3VkTE4zTGFLRnpQLWJBMFE6RUF2RXA5OUhUWmlXMzhsMGFIRFRyUmNMSURTQVp3X2VZdlRVU25seXRUYkhHU214SVVvUEl6eU5qUkJhNmVVMFZORWRQUWpvM0hOQ0I4cVY'
  @@paypal_token = String.new

  included do
    before_action :get_token
  end

  private

  def get_token

    @@paypal_token = HTTParty.post('https://api.sandbox.paypal.com/v1/oauth2/token',
      headers: {
        'Accept' => 'application/json',
        'Accept-Language' => 'fr_FR',
        'Content-Type' => 'application/x-www-form-urlencoded',
        'Authorization' => 'Basic '+@@paypal_key
        },
      body: {
        'grant_type' => 'client_credentials'
      }
    )['access_token']

  end

  def self.simplePayment(amount)
    HTTParty.post('https://api.sandbox.paypal.com/v1/payments/payment',
      headers: {
        'Content-Type' => 'application/json',
        'Authorization' => 'Bearer '+@@paypal_token,
        },
      body: {
        "intent": "sale",
        "redirect_urls":
          {
            "return_url": "http://127.0.0.1:3000/",
            "cancel_url": "http://127.0.0.1:3000/"
          },
          "payer":
          {
            "payment_method": "paypal"
          },
          "transactions": [
          {
            "amount":
            {
              "total": amount.to_s,
              "currency": "EUR"
            },
            "description": "Adhésion à vaincre l'autisme pour un montant de "+amount.to_s+"€."
          }]
      }.to_json)
  end

end