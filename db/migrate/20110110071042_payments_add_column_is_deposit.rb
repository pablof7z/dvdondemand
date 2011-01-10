class PaymentsAddColumnIsDeposit < ActiveRecord::Migration
  def self.up
    add_column :payments, :is_test_deposit, :boolean, :default => false
  end

  def self.down
    remove_column :payments, :is_test_deposit
  end
end
