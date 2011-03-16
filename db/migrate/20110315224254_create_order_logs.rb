class CreateOrderLogs < ActiveRecord::Migration
  def self.up
    create_table :order_logs do |t|
      t.references :order
      t.string :status
      t.string :priority
      t.string :source
      t.text :description
      t.timestamps
    end
  end

  def self.down
    drop_table :order_logs
  end
end
