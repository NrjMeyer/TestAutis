class CreateAdvantages < ActiveRecord::Migration[5.0]
  def change
    create_table :advantages do |t|
      t.text :description
      
      t.timestamps
    end

    create_table :advantages_offers, id: false do |t|
      t.belongs_to :advantage, index: true
      t.belongs_to :offer, index: true
    end

  end
end
