class CreateItemsProducts < ActiveRecord::Migration
  def self.up
    create_table :items_products, :id => false do |t|
      t.integer :item_id
      t.integer :product_id
    end
  end

  def self.down
    drop_table :items_products
  end
end
