class CreatePublisherPayments < ActiveRecord::Migration
  def self.up
    create_table :publisher_payments do |t|
      t.string :payment_gateway
      t.string :transaction_code
      t.string :status_code
      t.datetime :date_processed
      t.integer :check_number
      t.float :amount
      t.references :publisher
      t.references :sale

      t.timestamps
    end
  end

  def self.down
    drop_table :publisher_payments
  end
end
