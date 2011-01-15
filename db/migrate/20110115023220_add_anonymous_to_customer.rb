class AddAnonymousToCustomer < ActiveRecord::Migration
  def self.up
    add_column :customers, :anonymous, :boolean, :default => false
  end

  def self.down
    remove_column :customers, :anonymous
  end
end
