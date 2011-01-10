class AddWholesaleToSales < ActiveRecord::Migration
  def self.up
    # actually for creating STI sales as Retail, GetStock, Wholesale
    rename_column :sales, :sale_type, :type
  end

  def self.down
    rename_column :sales, :type, :sale_type
  end
end
