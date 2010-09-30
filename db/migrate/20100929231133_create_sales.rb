class CreateSales < ActiveRecord::Migration
  def self.up
    create_table :sales do |t|
      t.references :publisher
      t.string :sale_type
      t.float :net_amount
      t.float :total

      t.timestamps
    end
  end

  def self.down
    drop_table :sales
  end
end
