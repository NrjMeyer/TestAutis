module Slimpay
  extend ActiveSupport::Concern
  require 'date'

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

  def self.simpleIbanPayment(token, amount, user)
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
            reference: user.email
          },
          items: [
            {
                type: "signMandate",
                autoGenReference: true,
                mandate: {
                    signatory: {
                        billingAddress: {
                            street1: user.address,
                            street2: user.address_extend,
                            city: user.city,
                            postalCode: user.post_code,
                            country: "FR"
                        },
                        honorificPrefix: "Mr",
                        familyName: user.surname,
                        givenName: user.name,
                        email: user.email,
                        telephone: "+33"+user.phone_number[1..-1]
                    },
                    standard: "SEPA"
                }
            },
            {
                type: "directDebit",
                directDebit: {
                    amount: amount,
                    paymentReference: user.hash.to_s,
                    label: "Virement à Vaincre l\'autisme"
                }
            },
          ]
        }.to_json
      )
  end

  def self.recurringIbanPayment(token, amount, user, don = false)
    if don == false
      monthly_amount = amount / 12
      description = "Payement de votre adhésion vraincre l\'autisme sur 12 mois pour "+amount.to_s+"€"
    else
      monthly_amount = amount
      description = "Don récurrent à vaincre l\'autisme de "+amount.to_s+"€ sur 12 mois"
    end
    
    t = DateTime.now + 7
    date = t.strftime('%Y-%m-%d')

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
            reference: user.email
          },
          items: [
            {
              type: "signMandate",
              autoGenReference: true,
              mandate: {
                  signatory: {
                      billingAddress: {
                        street1: user.address,
                        street2: user.address_extend,
                        city: user.city,
                        postalCode: user.post_code,
                        country: "FR"
                      },
                      honorificPrefix: "Mr",
                      familyName: user.surname,
                      givenName: user.name,
                      email: user.email,
                      telephone: "+33"+user.phone_number[1..-1]
                  },
                  standard: "SEPA"
              }
          },
          {
              type: "recurrentDirectDebit",
              recurrentDirectDebit: {
                  amount: monthly_amount,
                  label: description,
                  frequency: "monthly",
                  maxSddNumber: 12,
                  activated: true,
                  dateFrom: "#{date}T12:00:00.900+0000"
              }
          },
          ]
        }.to_json
      )
  end

end
