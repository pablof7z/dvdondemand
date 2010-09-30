class CreateShippingOptions < ActiveRecord::Migration
  def self.up
    create_table :shipping_options do |t|
      t.string :title
      t.integer :maximium_weight
      t.boolean :priority
      t.float :price

      t.timestamps
    end
  end

  def self.down
    drop_table :shipping_options
  end
end
