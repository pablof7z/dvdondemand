class CreateCustomerPayments < ActiveRecord::Migration
  def self.up
    create_table :customer_payments do |t|
      t.string :method
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
