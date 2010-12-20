class PublisherRemoveFinancialColumns < ActiveRecord::Migration
  def self.up
    remove_column :publishers, :financial_payable_to
    remove_column :publishers, :financial_ssn
    remove_column :publishers, :financial_bank_name
    remove_column :publishers, :financial_account
    remove_column :publishers, :financial_routing
  end

  def self.down
    add_column :publishers, :financial_payable_to, :string
    add_column :publishers, :financial_ssn, :string
    add_column :publishers, :financial_bank_name, :string
    add_column :publishers, :financial_account, :string
    add_column :publishers, :financial_routing, :string
  end
end
