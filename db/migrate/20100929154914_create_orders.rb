class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|
      t.references :customer
      t.references :sale
      t.datetime   :date_received
      t.datetime   :date_shipped
      t.datetime   :purchased_at
      t.string     :card_type
      t.date       :card_expires_on
      t.string     :ip_address
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

