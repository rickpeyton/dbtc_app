class CreateChains < ActiveRecord::Migration
  def change
    create_table :chains do |t|
      t.text :name
      t.integer :user_id
      t.timestamps
    end
  end
end
