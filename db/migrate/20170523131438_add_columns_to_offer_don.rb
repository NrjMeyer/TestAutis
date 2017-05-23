class AddColumnsToOfferDon < ActiveRecord::Migration[5.0]
  def change
    add_column :offer_dons, :amount, :integer
    add_column :offer_dons, :story, :string
  end
end
