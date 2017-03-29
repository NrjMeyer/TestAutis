class CreateDons < ActiveRecord::Migration[5.0]
  def change
    create_table :dons do |t|
      t.integer :amount
      t.string :user_id
      t.string :cache_user_id

      t.timestamps
    end
  end
end
