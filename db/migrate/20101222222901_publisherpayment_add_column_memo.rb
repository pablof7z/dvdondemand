class PublisherpaymentAddColumnMemo < ActiveRecord::Migration
  def self.up
    add_column :payments, :memo, :text
  end

  def self.down
    remove_column :payments, :memo
  end
end
