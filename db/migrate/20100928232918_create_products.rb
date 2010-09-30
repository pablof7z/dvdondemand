class CreateProducts < ActiveRecord::Migration
  def self.up
    create_table :products do |t|
      t.string :product_type
      t.string :title
      t.string :studio
      t.text :description
      t.float :price
      t.integer :running_time
      t.references :publisher
      t.timestamps
    end
  end

  def self.down
    drop_table :products
  end
end
