class AddTimesSoldToProduct < ActiveRecord::Migration
  def self.up
    add_column :products, :times_sold, :integer, :default => 0
    add_index :products, :times_sold
  end

  def self.down
    remove_index :products, :times_sold
    remove_column :products, :times_sold
  end
end
