class AddRoleToOffers < ActiveRecord::Migration[5.0]
  def change
    add_column :offers, :role, :string
  end
end
