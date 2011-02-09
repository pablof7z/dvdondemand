class AddPubFinancialInformation < ActiveRecord::Migration
  def self.up
    add_column :publishers, :financial_payable_to, :string
    add_column :publishers, :financial_ssn, :string
    add_column :publishers, :financial_bank_name, :string
    add_column :publishers, :financial_account, :string
    add_column :publishers, :financial_routing, :string
  end

  def self.down
  end
end
