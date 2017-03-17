class AddAmountToPaypalPayment < ActiveRecord::Migration[5.0]
  def change
    add_column :paypal_payments, :amount, :integer
  end
end
