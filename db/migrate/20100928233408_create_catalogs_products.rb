class CreateCatalogsProducts < ActiveRecord::Migration
  def self.up
    create_table :catalogs_products, :id => false do |t|
      t.integer :catalog_id
      t.integer :product_id
    end
  end

  def self.down
    drop_table :catalogs_products
  end
end
