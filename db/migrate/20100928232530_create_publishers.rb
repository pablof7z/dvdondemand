class CreatePublishers < ActiveRecord::Migration
  def self.up
    create_table :publishers do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.text :address
      t.boolean :approved
      t.float :production_fee
      t.float :processing_fee
      t.float :get_stock_unit_price
      t.timestamps
    end
  end

  def self.down
    drop_table :publishers
  end
end
