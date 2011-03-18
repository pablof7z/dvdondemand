class AddDeletedToPublishers < ActiveRecord::Migration
  def self.up
    add_column :publishers, :deleted_at, :datetime
  end

  def self.down
    remove_column :publishers, :deleted_at
  end
end
