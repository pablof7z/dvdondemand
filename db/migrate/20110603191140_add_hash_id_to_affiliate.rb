class AddHashIdToAffiliate < ActiveRecord::Migration
  def self.up
    add_column :affiliates, :hash_id, :string, :unique => true
  end

  def self.down
    remove_column :affiliates, :hash_id
  end
end
