class CreateOrderTransactions < ActiveRecord::Migration
  def self.up
    create_table :order_transactions do |t|
      t.references :order
      t.string  :action
      t.integer :amount
      t.boolean :success
      t.string  :authorization
      t.string  :message
      t.text    :params
      t.boolean :test
      t.timestamps
    end
  end

  def self.down
    drop_table :order_transactions
  end
end

