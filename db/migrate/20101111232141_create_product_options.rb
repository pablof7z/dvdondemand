class CreateProductOptions < ActiveRecord::Migration
  def self.up
    create_table :product_options do |t|
      t.references :product
      t.references :packaging_option
    end
  end

  def self.down
    drop_table :product_options
  end
end

