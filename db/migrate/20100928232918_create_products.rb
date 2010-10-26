class CreateProducts < ActiveRecord::Migration
  def self.up
    create_table :products do |t|
      t.references :publisher
      t.references :genre
      t.string :title
      t.string :studio
      t.text :description
      t.float :price
      t.integer :running_time
      t.timestamps
    end
  end

  def self.down
    drop_table :products
  end
end

