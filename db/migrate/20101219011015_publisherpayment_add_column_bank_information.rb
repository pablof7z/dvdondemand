class PublisherpaymentAddColumnBankInformation < ActiveRecord::Migration
  def self.up
    add_column :publisher_payments, :bank_information_id, :integer
  end

  def self.down
    remove_column :publisher_payments, :bank_information_id
  end
end
