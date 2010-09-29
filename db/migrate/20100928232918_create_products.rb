class CreateProducts < ActiveRecord::Migration
  def self.up
    create_table :products do |t|
      t.string :name
      t.string :studio
      t.float :price
      t.float :whole_price
      t.float :runtime
      t.references :publisher
      t.timestamps
    end
  end

  def self.down
    drop_table :products
  end
end
