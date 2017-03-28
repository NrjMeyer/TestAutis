class AddColumnsToPaymentCheque < ActiveRecord::Migration[5.0]
  def change
    add_column :payment_cheques, :amount, :integer
    add_column :payment_cheques, :validated, :boolean
    add_column :payment_cheques, :user_id, :string
  end
end
