class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|
      t.datetime :date_received
      t.datetime :date_shipped
      t.references :publisher

      t.timestamps
    end
  end

  def self.down
    drop_table :orders
  end
end
