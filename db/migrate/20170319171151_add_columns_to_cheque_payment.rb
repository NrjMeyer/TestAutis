class AddColumnsToChequePayment < ActiveRecord::Migration[5.0]
  def change
    add_column :cheque_payments, :amount, :integer
    add_column :cheque_payments, :validated, :boolean
    add_column :cheque_payments, :user_id, :integer
    add_column :cheque_payments, :cache_user_id, :integer
  end
end
