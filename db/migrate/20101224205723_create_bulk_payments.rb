class CreateBulkPayments < ActiveRecord::Migration
  def self.up
    create_table :bulk_payments do |t|
      t.text :paypal_file
      t.text :ach_file

      t.timestamps
    end
    add_column :payments, :bulk_payment_id, :integer
  end

  def self.down
    drop_table :bulk_payments
    remove_column :payments, :bulk_payment_id
  end
end
