class AddColumnsToDon < ActiveRecord::Migration[5.0]
  def change
    add_column :dons, :slimpay_payment_id, :integer
    add_column :dons, :paypal_payment_id, :integer
    add_column :dons, :card_payment_id, :integer
    add_column :dons, :cheque_payment_id, :integer
    add_column :dons, :validated, :boolean, default: false
    add_column :dons, :recurring, :boolean
    add_column :dons, :donor_name, :string
    add_column :dons, :donor_mail, :string
    add_column :dons, :donor_surname, :string
    add_column :dons, :donor_adress, :string
    add_column :dons, :donor_phone, :string
    add_column :dons, :fiscal_mail, :boolean
  end
end
