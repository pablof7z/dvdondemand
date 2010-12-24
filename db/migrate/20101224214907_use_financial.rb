class UseFinancial < ActiveRecord::Migration
  def self.up
    create_table :financial_informations do |t|
      t.integer :publisher_id
      t.string :payment_method
      t.string :paypal_email
      t.string :bank_account_number
      t.string :bank_routing_number
      t.string :bank_name
      t.string :bank_account_type
      t.boolean :validated
      t.boolean :default
      t.integer :deposit1_id
      t.integer :deposit2_id

      t.timestamps
    end
    add_column :publisher_payments, :financial_information_id, :integer
  end

  def self.down
    drop_table :financial_informations
    remove_column :publisher_payments, :financial_information_id
  end
end
