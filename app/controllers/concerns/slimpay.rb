module Slimpay
  extend ActiveSupport::Concern

  @@slimpay_app_id = 'vaincrelautisme01'
  @@slimpay_app_secret = '8pgWCFFqomyeQdHhmJRALIwujEekvH8UBsaZnw0X'
  @@slimpay_creditor_reference = 'vaincrelautisme'
  @@slimpay_token = String.new
  @@slimpay_links = Array.new
  @@slimpay_server = 'https://api-sandbox.slimpay.net'

  included do
    before_action :get_token
  end

  private

  def get_token
    encoded_key = Base64.strict_encode64(@@slimpay_app_id+':'+@@slimpay_app_secret)
    authorization = 'Basic '+ encoded_key
    @@slimpay_token = HTTParty.post(@@slimpay_server+'/oauth/token',
        headers: {
          'Accept'        => 'application/json',
          'Content-Type'  => 'application/x-www-form-urlencoded',
          'Authorization' => authorization
        },
        body: {
          :grant_type => 'client_credentials',
          :scope      => 'api'
        }.to_query
      )['access_token']

    @@slimpay_links = HTTParty.get('https://api-sandbox.slimpay.net/',
      headers: {
        'Accept' => 'application/hal+json; profile="https://api.slimpay.net/alps/v1"',
        'Content-Type' => 'application/json',
        'Authorization' => 'Bearer ' + @@slimpay_token
      }
    )
  end

  def self.simpleIbanPayment(amount)
    puts @@slimpay_links#[_links]['https://api.slimpay.net/alps#create-orders']["href"]
    order = HTTParty.post(@@slimpay_links["_links"]['https://api.slimpay.net/alps#create-orders']["href"],
        headers: {
          'Accept' => 'application/hal+json; profile="https://api.slimpay.net/alps/v1"',
          'Content-Type' => 'application/json',
          'Authorization' => 'Bearer ' + @@slimpay_token
        },
        body: {
          started: true,
          creditor: {
            reference: @@slimpay_creditor_reference
          },
          subscriber: {
            reference: 'user1'
          },
          items: [
            {
                type: "signMandate",
                autoGenReference: true,
                mandate: {
                    signatory: {
                        billingAddress: {
                            street1: "27 rue des fleurs",
                            street2: "Bat 2",
                            city: "Paris",
                            postalCode: "75008",
                            country: "FR"
                        },
                        honorificPrefix: "Mr",
                        familyName: "Doe",
                        givenName: "John",
                        email: "change.me@slimpay.com",
                        telephone: "+33612345678"
                    },
                    standard: "SEPA"
                }
            },
            {
                type: "directDebit",
                directDebit: {
                    amount: amount,
                    paymentReference: "mypayment",
                    label: "This is my Direct Debit"
                }
            },
          ]
        }.to_json

      )
  end

end