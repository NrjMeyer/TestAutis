class ConfirmationsController < Devise::ConfirmationsController
  private
  def after_confirmation_path_for(resource_name, resource)
    url = "https://api.sandbox.paypal.com/v1/payments/payment/#{resource.payment_id}/execute"
    payment = HTTParty.post(url,
      headers: {
        'Content-Type' => 'application/json',
        'Authorization' => 'Bearer ' + resource.payment_token,
      },
      body: {
        :payer_id => resource.payer_id
      })
    puts '---------------------'
    puts payment
    puts '---------------------'
  end
end
