class CreatePaymentCheques < ActiveRecord::Migration[5.0]
  def change
    create_table :payment_cheques do |t|

      t.timestamps
    end
  end
end
