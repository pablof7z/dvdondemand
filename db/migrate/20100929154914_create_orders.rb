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

      # billing address w/same columns as Customers'
      t.string     :billing_address1
      t.string     :billing_address2
      t.string     :billing_city
      t.string     :billing_state
      t.string     :billing_zip_code
      t.string     :billing_country
      # so should be shipping address
      t.text       :shipping_address

      t.boolean    :returned

      t.timestamps
    end
  end

  def self.down
    drop_table :orders
  end
end

