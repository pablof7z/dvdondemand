class CreatePackagingOptions < ActiveRecord::Migration
  def self.up
    create_table :packaging_options do |t|
      t.string :title
      t.integer :weight
      t.float :price
      t.timestamps
    end
  end

  def self.down
    drop_table :packaging_options
  end
end
