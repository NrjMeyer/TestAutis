class CreatePaypalPayments < ActiveRecord::Migration[5.0]
  def change
    create_table :paypal_payments do |t|

      t.timestamps
    end
  end
end
