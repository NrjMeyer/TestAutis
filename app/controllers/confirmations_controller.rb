class ConfirmationsController < Devise::ConfirmationsController
  private
  def after_confirmation_path_for(resource_name, resource)
    execute_payment_path( payment_id: resource.payment_id,
      payer_id: resource.payer_id,
      payment_token: resource.payment_token
    )
  end
end
