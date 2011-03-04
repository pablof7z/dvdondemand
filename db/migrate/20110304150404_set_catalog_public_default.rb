class SetCatalogPublicDefault < ActiveRecord::Migration
  def self.up
    change_column_default('catalogs', :private, false)
  end

  def self.down
    change_column_default('catalogs', :private, nil)
  end
end
