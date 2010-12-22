class BankInformationAddColumnsValidations < ActiveRecord::Migration
  def self.up
    add_column :bank_informations, :deposit1_id, :integer
    add_column :bank_informations, :deposit2_id, :integer
  end

  def self.down
    remove_column :bank_informations, :deposit1_id
    remove_column :bank_informations, :deposit2_id
  end
end
