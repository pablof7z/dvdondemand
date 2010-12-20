class OrderAddColumnWholesalerId < ActiveRecord::Migration
  def self.up
    add_column :orders, :wholesaler_id, :integer
  end

  def self.down
    remove_column :orders, :wholesaler_id
  end
end
