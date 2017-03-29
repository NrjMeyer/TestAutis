class AddColumnsToDon < ActiveRecord::Migration[5.0]
  def change
    add_column :dons, :slimpay_payment_id, :string
    add_column :dons, :paypal_payment_id, :string
    add_column :dons, :cheque_payment_id, :string
  end
end
