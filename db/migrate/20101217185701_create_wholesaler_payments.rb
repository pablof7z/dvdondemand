class CreateWholesalerPayments < ActiveRecord::Migration
  def self.up
    create_table :wholesaler_payments do |t|
      t.integer :wholesaler_invoice_id
      t.string :payment_gateway
      t.string :transaction_code
      t.string :status_code
      t.datetime :date_processed
      t.string :check_number
      t.float :amount

      t.timestamps
    end
  end

  def self.down
    drop_table :wholesaler_payments
  end
end
