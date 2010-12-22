class CreateBankInformations < ActiveRecord::Migration
  def self.up
    create_table :bank_informations do |t|
      t.integer :publisher_id
      t.string :account_number
      t.string :routing_number
      t.string :bank_name
      t.string :account_type
      t.boolean :validated
      t.boolean :default

      t.timestamps
    end
  end

  def self.down
    drop_table :bank_informations
  end
end
