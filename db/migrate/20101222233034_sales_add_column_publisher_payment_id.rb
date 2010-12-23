class SalesAddColumnPublisherPaymentId < ActiveRecord::Migration
  def self.up
    add_column :sales, :publisher_payment_id, :integer
    remove_column :publisher_payments, :sale_id
  end

  def self.down
    remove_column :sales, :publisher_payment_id
    add_column :publisher_payments, :sale_id, :integer
  end
end
