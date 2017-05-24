module Slimpay
  extend ActiveSupport::Concern

  private

  def self.get_token
    authorization = 'Basic '+ Settings.slimpay.encoded_key
    response = HTTParty.post(Settings.slimpay.server+'/oauth/token',
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

  def self.simpleCardPayment(token, amount, email)
    HTTParty.post(Settings.slimpay.server + Settings.slimpay.url.create_order,
      headers: {
        'Accept' => 'application/hal+json; profile="https://api.slimpay.net/alps/v1"',
        'Content-Type' => 'application/json',
        'Authorization' => 'Bearer ' + token
        },
        body: {
          started: true,
          creditor: {
              reference: Settings.slimpay.creditor_reference
          },
          subscriber: {
              reference: email
          },
          items: [
            {
              type: "cardTransaction",
              cardTransaction: {
                  amount: amount,
                  operation: "authorizationDebit"
              }
            }
          ]
        }.to_json
    )
  end

  def self.simpleIbanPayment(token, amount, email)
    HTTParty.post(Settings.slimpay.server + Settings.slimpay.url.create_order,
        headers: {
          'Accept' => 'application/hal+json; profile="https://api.slimpay.net/alps/v1"',
          'Content-Type' => 'application/json',
          'Authorization' => 'Bearer ' + token
        },
        body: {
          started: true,
          creditor: {
            reference: Settings.slimpay.creditor_reference
          },
          subscriber: {
            reference: email
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
                        email: email,
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

  def self.recurringIbanPayment(token, amount, email, don = false)
    if don == false
      monthly_amount = amount / 12
    else
      monthly_amount = amount
    end
    
    HTTParty.post(Settings.slimpay.server + Settings.slimpay.url.create_order,
        headers: {
          'Accept' => 'application/hal+json; profile="https://api.slimpay.net/alps/v1"',
          'Content-Type' => 'application/json',
          'Authorization' => 'Bearer ' + token
        },
        body: {
          started: true,
          creditor: {
            reference: Settings.slimpay.creditor_reference
          },
          subscriber: {
            reference: email
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
                      email: "email@qzfqer.fr",
                      telephone: "+33612345678"
                  },
                  standard: "SEPA"
              }
          },
          {
              type: "recurrentDirectDebit",
              recurrentDirectDebit: {
                  amount: monthly_amount,
                  label: "This is my Recurrent Direct Debit",
                  frequency: "monthly",
                  maxSddNumber: 12,
                  activated: true,
                  dateFrom: "2017-11-04T13:11:52.900+0000"
              }
          },
          ]
        }.to_json
      )
  end

end
