class AddPostBackShippingFieldsToOrder < ActiveRecord::Migration
  def self.up
    add_column :orders, :shipping_status, :string
    add_column :orders, :shipping_tracking_number, :string
    add_column :orders, :shipping_postage_amount, :float
  end

  def self.down
    remove_column :orders, :shipping_postage_amount
    remove_column :orders, :shipping_tracking_number
    remove_column :orders, :shipping_status
  end
end
