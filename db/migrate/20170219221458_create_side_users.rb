class CreateSideUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :side_users do |t|
      t.string :name
      t.string :surname
      t.string :email

      t.timestamps
    end
  end
end
