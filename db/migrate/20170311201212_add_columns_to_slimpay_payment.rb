class AddColumnsToSlimpayPayment < ActiveRecord::Migration[5.0]
  def change
      add_column :slimpay_payments, :user_id, :string
      add_column :slimpay_payments, :cache_user_id, :string
      add_column :slimpay_payments, :payment_reference, :string
      add_column :slimpay_payments, :amount, :integer
  end
end
