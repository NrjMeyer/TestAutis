class CreateCardPayment < ActiveRecord::Migration[5.0]
  def change
    create_table :card_payments do |t|
    
      t.timestamps
    end
  end
end
