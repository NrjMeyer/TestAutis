class CreateOfferDons < ActiveRecord::Migration[5.0]
  def change
    create_table :offer_dons do |t|

      t.timestamps
    end
  end
end
