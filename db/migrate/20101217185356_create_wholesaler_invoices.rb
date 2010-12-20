class CreateWholesalerInvoices < ActiveRecord::Migration
  def self.up
    create_table :wholesaler_invoices do |t|
      t.integer :wholesaler_id

      t.timestamps
    end
  end

  def self.down
    drop_table :wholesaler_invoices
  end
end
