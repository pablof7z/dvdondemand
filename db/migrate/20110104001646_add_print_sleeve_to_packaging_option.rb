class AddPrintSleeveToPackagingOption < ActiveRecord::Migration
  def self.up
    add_column :packaging_options, :print_sleeve, :boolean
  end

  def self.down
    remove_column :packaging_options, :print_sleeve
  end
end
