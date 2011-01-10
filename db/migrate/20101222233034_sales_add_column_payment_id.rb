class SalesAddColumnPaymentId < ActiveRecord::Migration
  def self.up
    add_column :sales, :payment_id, :integer
    remove_column :payments, :sale_id
  end

  def self.down
    remove_column :sales, :payment_id
    add_column :payments, :sale_id, :integer
  end
end
