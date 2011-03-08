class SplitShippingNameOnOrder < ActiveRecord::Migration
  def self.up
    rename_column :orders, :shipping_name, :shipping_first_name
    add_column    :orders, :shipping_last_name, :string
  end

  def self.down
    remove_column :orders, :shipping_last_name
    rename_column :orders, :shipping_first_name, :shipping_name
  end
end
