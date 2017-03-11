class AddColumnsToPaypalPayment < ActiveRecord::Migration[5.0]
  def change
    add_column :paypal_payments, :payment, :string
    add_column :paypal_payments, :payer, :string
    add_column :paypal_payments, :token, :string
  end
end