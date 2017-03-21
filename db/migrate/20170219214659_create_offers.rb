class CreateOffers < ActiveRecord::Migration[5.0]
  def change
    create_table :offers do |t|
      t.integer :amount
      t.boolean :mensualisable

      t.timestamps
    end
  end
end
