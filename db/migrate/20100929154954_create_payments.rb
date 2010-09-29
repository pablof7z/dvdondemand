class CreatePayments < ActiveRecord::Migration
  def self.up
    create_table :payments do |t|
      t.float :amount
      t.references :sale
      t.timestamps
    end
  end

  def self.down
    drop_table :payments
  end
end
