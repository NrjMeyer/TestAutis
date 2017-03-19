class ConfirmationsController < Devise::ConfirmationsController
  private
  def after_confirmation_path_for(resource_name, resource)
    if resource.payment_option == 'paypal'
      execute_payment_path(payment_option: 'paypal',
      payment_id: resource.paypal_payment.payment,
      payer_id: resource.paypal_payment.payer,
      payment_token: resource.paypal_payment.token,
      monthly_payment: resource.monthly_payment
    )
    else
      payment = SlimpayPayment.where(user_id: resource.id).last
      execute_payment_path( payment_option: 'slimpay',
      email: resource.email,
      reference: payment.payment_reference,
      amount: payment.amount
    )
    end
  end
end
