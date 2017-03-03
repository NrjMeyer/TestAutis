module Slimpay
  extend ActiveSupport::Concern
  attr_accessor :slimpay_token
  attr_accessor :links

  private

  included do
    before_action :get_token
  end

  def get_token
    authorization = 'Basic '+ Settings.slimpay.encoded_key
    @@slimpay_token = HTTParty.post(Settings.slimpay.server+'/oauth/token',
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
  end

  def self.simpleIbanPayment(amount)
    puts @@slimpay_token
    HTTParty.post(Settings.slimpay.url.create_order,
        headers: {
          'Accept' => 'application/hal+json; profile="https://api.slimpay.net/alps/v1"',
          'Content-Type' => 'application/json',
          'Authorization' => 'Bearer ' + @@slimpay_token
        },
        body: {
          started: true,
          creditor: {
            reference: Settings.slimpay.creditor_reference
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
