class AddColumnsToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :name, :string
    add_column :users, :surname, :string
    add_column :users, :phone_number, :string
    add_column :users, :address, :text
    add_column :users, :address_extend, :text
    add_column :users, :post_code, :integer
    add_column :users, :city, :string
    add_column :users, :tax_receipt, :boolean
    add_column :users, :sub_newsletter, :boolean
  end
end
