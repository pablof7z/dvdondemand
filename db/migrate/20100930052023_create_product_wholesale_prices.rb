class CreateProductWholesalePrices < ActiveRecord::Migration
  def self.up
    create_table :product_wholesale_prices do |t|
      t.integer :product_id
      t.integer :from_quantity
      t.float :discount_percentage

      t.timestamps
    end
  end

  def self.down
    drop_table :product_wholesale_prices
  end
end
