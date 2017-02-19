class CreateAdvantages < ActiveRecord::Migration[5.0]
  def change
    create_table :advantages do |t|
      t.text :description

      t.timestamps
    end
  end
end
