class CustomerAddColumnWholesalerId < ActiveRecord::Migration
  def self.up
    add_column :customers, :wholesaler_id, :integer
  end

  def self.down
    remove_column :customers, :wholesaler_id
  end
end
