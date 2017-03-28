class CreateSideUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :side_users do |t|
      t.string :user_id
      t.string :cache_user_id
      t.string :name
      t.string :email

      t.timestamps
    end
  end
end
