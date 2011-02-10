class AddFlagCountToProduct < ActiveRecord::Migration
  def self.up
    add_column :products, :flag_count, :integer
  end

  def self.down
    remove_column :products, :flag_count
  end
end
