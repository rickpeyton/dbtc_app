class AddColumntoChains < ActiveRecord::Migration
  def change
    add_column :chains, :longest_chain, :integer
  end
end
