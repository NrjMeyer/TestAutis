class AddColumnsToCacheUser < ActiveRecord::Migration[5.0]
  def change
    add_column :cache_users, :name, :string
    add_column :cache_users, :surname, :string
    add_column :cache_users, :phone_number, :string
    add_column :cache_users, :address, :text
    add_column :cache_users, :address_extend, :text
    add_column :cache_users, :post_code, :integer
    add_column :cache_users, :city, :string
    add_column :cache_users, :tax_receipt, :boolean
    add_column :cache_users, :sub_newsletter, :boolean
    add_column :cache_users, :payment_id, :string
  end
end
