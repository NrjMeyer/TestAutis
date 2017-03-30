class CreateSlimpayPayments < ActiveRecord::Migration[5.0]
  def change
    create_table :slimpay_payments do |t|

      t.timestamps
    end
  end
end
