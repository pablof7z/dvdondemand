class CreateCatalogsProducts < ActiveRecord::Migration
  def self.up
    create_table :catalogs_products, :id => false do |t|
      t.references :catalog
      t.references :product
    end
  end

  def self.down
    drop_table :catalogs_products
  end
end
