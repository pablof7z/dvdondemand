class AddPublisherToOrder < ActiveRecord::Migration
  def self.up
    add_column :orders, :publisher_id, :integer
  end

  def self.down
    remove_column :orders, :publisher_id
  end
end
