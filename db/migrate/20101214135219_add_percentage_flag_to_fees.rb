class AddPercentageFlagToFees < ActiveRecord::Migration
  def self.up
    add_column :fees, :percentage, :boolean
  end

  def self.down
    remove_column :fees, :percentage
  end
end
