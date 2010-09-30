class CreatePublisherPayments < ActiveRecord::Migration
  def self.up
    create_table :publisher_payments do |t|
      t.string :method
      t.string :transaction_code
      t.float :amount
      t.datetime :date_paid
      t.references :publisher
      t.references :sale

      t.timestamps
    end
  end

  def self.down
    drop_table :publisher_payments
  end
end
