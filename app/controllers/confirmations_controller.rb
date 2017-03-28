class ConfirmationsController < Devise::ConfirmationsController
  private
  def after_confirmation_path_for(resource_name, resource)
    if resource.payment_option == 'paypal'
      payment = PaypalPayment.where(user_id: resource.id).last
      execute_payment_path(payment_option: 'paypal',
      payment_id: payment.payment,
      payer_id: payment.payer,
      payment_token: payment.token,
      monthly_payment: resource.monthly_payment
    )
    elsif resource.payment_option == 'slimpay'
      payment = SlimpayPayment.where(user_id: resource.id).last
      execute_payment_path( payment_option: 'slimpay',
      email: resource.email,
      reference: payment.payment_reference,
      amount: payment.amount
    )
    elsif resource.payment_option == 'cheque'
      payment = PaymentCheque.where(user_id: resource.id).last
      execute_payment_path( payment_option: 'cheque',
      id: resource.id,
      amount: resource.payment.amount,
      activated: resource.payment.activated,
    )
    end
  end
end
