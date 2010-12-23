class PublisherpaymentAddColumnMemo < ActiveRecord::Migration
  def self.up
    add_column :publisher_payments, :memo, :text
  end

  def self.down
    remove_column :publisher_payments, :memo
  end
end
