class AddPrivateToCatalogs < ActiveRecord::Migration
  def self.up
    add_column :catalogs, :private, :boolean
    add_column :catalogs, :password, :string
  end

  def self.down
    remove_column :catalogs, :password
    remove_column :catalogs, :private
  end
end
