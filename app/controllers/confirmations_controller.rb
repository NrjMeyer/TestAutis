class ConfirmationsController < Devise::ConfirmationsController
  private
  def after_confirmation_path_for(resource_name, resource)
    execute_payment_path( payment_id: resource.paypal_payment.payment,
      payer_id: resource.paypal_payment.payer,
      payment_token: resource.paypal_payment.token
    )
  end
end
