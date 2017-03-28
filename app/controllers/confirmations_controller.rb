class ConfirmationsController < Devise::ConfirmationsController
  private
  def after_confirmation_path_for(resource_name, resource)
    cookies.signed.encrypted[:user_id] = resource.id
    execute_payment_path
  end
end
