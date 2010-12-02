class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|
      t.references :customer
      t.references :sale
      t.references :shipping_option
      t.datetime   :date_received
      t.datetime   :date_shipped
      t.string     :tracking_code
      t.text       :billing_address
      t.text       :shipping_address
      t.boolean    :returned

      t.timestamps
    end
  end

  def self.down
    drop_table :orders
  end
end

