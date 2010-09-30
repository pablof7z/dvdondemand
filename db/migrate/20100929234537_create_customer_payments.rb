class CreateCustomerPayments < ActiveRecord::Migration
  def self.up
    create_table :customer_payments do |t|
      t.string :payment_gateway
      t.string :transaction_code
      t.string :status_code
      t.boolean :rejected
      t.datetime :date_processed
      t.float :amount
      t.references :customer
      t.references :order

      t.timestamps
    end
  end

  def self.down
    drop_table :customer_payments
  end
end
