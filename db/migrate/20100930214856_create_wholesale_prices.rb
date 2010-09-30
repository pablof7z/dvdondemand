class CreateWholesalePrices < ActiveRecord::Migration
  def self.up
    create_table :wholesale_prices do |t|
      t.integer :minimum_quantity
      t.float :discount_percentage
      t.boolean :enabled
      t.references :product

      t.timestamps
    end
  end

  def self.down
    drop_table :wholesale_prices
  end
end
