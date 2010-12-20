class CreateWholesalerPaymentTransactions < ActiveRecord::Migration
  def self.up
    create_table :wholesaler_payment_transactions do |t|
      t.integer :wholesaler_payment_id
      t.string :action
      t.integer :amount
      t.boolean :success
      t.string :authorization
      t.string :message
      t.text :params
      t.boolean :test

      t.timestamps
    end
  end

  def self.down
    drop_table :wholesaler_payment_transactions
  end
end
