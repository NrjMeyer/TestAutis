class CreateCacheUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :cache_users do |t|

      t.timestamps
    end
  end
end
