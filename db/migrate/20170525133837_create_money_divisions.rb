class CreateMoneyDivisions < ActiveRecord::Migration[5.0]
  def change
    create_table :money_divisions do |t|

      t.timestamps
    end
  end
end
