class AddDeletedToFees < ActiveRecord::Migration
  def self.up
    add_column :fees, :deleted_at, :datetime
  end

  def self.down
    remove_column :fees, :deleted_at
  end
end
