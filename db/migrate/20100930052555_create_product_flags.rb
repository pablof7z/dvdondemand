class CreateProductFlags < ActiveRecord::Migration
  def self.up
    create_table :product_flags do |t|
      t.integer :product_id
      t.string :comment

      t.timestamps
    end
  end

  def self.down
    drop_table :product_flags
  end
end
