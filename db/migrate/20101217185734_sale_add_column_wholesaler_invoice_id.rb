class SaleAddColumnWholesalerInvoiceId < ActiveRecord::Migration
  def self.up
    add_column :sales, :wholesaler_invoice_id, :integer
  end

  def self.down
    remove_column :sales, :wholesaler_invoice_id
  end
end
