class AddPartialCreditCardNumberToOrder < ActiveRecord::Migration
  def self.up
    add_column :orders, :partial_cc_number, :integer
  end

  def self.down
    remove_column :orders, :partial_cc_number
  end
end
