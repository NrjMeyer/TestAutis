class AddMonthlyPaymentToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :monthly_payment, :boolean
  end
end
