class AddFullAddressToPublisher < ActiveRecord::Migration
  def self.up
    rename_column :publishers, :address, :address1
    add_column :publishers, :address2, :string
    add_column :publishers, :company, :string
    add_column :publishers, :city, :string
    add_column :publishers, :state, :string
    add_column :publishers, :zip_code, :string
    add_column :publishers, :country, :string
  end

  def self.down
    rename_column :publishers, :address1, :address
    remove_column :publishers, :country
    remove_column :publishers, :zip_code
    remove_column :publishers, :state
    remove_column :publishers, :city
    remove_column :publishers, :company
    remove_column :publishers, :address2
  end
end

