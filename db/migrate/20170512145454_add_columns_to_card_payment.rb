class AddColumnsToCardPayment < ActiveRecord::Migration[5.0]
  def change
    add_column :card_payments, :user_id, :integer
    add_column :card_payments, :payment_reference, :string
    add_column :card_payments, :amount, :integer
  end
end
