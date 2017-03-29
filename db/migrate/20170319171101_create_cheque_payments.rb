class CreateChequePayments < ActiveRecord::Migration[5.0]
  def change
    create_table :cheque_payments do |t|

      t.timestamps
    end
  end
end
