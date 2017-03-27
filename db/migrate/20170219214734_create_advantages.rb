class CreateAdvantages < ActiveRecord::Migration[5.0]
  def change
    create_table :advantages do |t|
      t.text :description
      
      t.timestamps
    end

    create_table :advantages_offers, id: false do |t|
      t.belongs_to :advantages, index: true
      t.belongs_to :offers, index: true
    end

  end
end
