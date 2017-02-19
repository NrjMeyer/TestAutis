class AddLastPaymentToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :last_payment, :datetime
  end
end
