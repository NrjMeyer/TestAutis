class ConfirmationsController < Devise::ConfirmationsController
  private
  def after_confirmation_path_for(resource_name, resource)
    if resource.payment_option == 'slimpay'
      execute_payment_path(payment_option: 'paypal',
      payment_id: resource.paypal_payment.payment,
      payer_id: resource.paypal_payment.payer,
      payment_token: resource.paypal_payment.token
    )
    else
      execute_payment_path( payment_option: 'slimpay',
      reference: resource.slimpay_payment.payment_reference,
      amount: resource.slimpay_payment.amount
    )
    end
  end
end
