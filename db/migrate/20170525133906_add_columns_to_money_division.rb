class AddColumnsToMoneyDivision < ActiveRecord::Migration[5.0]
  def change
    add_column :money_divisions, :part, :integer
    add_column :money_divisions, :use, :string
  end
end
