class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.datetime :link_day
      t.integer :chain_id
      t.timestamps
    end
  end
end
