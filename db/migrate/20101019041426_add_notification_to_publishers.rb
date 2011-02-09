class AddNotificationToPublishers < ActiveRecord::Migration
  def self.up
    add_column :publishers, :notify_on_sale_retail, :boolean, :default => true
    add_column :publishers, :notify_on_sale_wholesale, :boolean, :default => true
    add_column :publishers, :notify_on_sale_royalty, :boolean, :default => true
  end

  def self.down
    remove_column :publishers, :notify_on_sale_retail
    remove_column :publishers, :notify_on_sale_wholesale
    remove_column :publishers, :notify_on_sale_royalty
  end
end
