class AddIsoColumnsToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :iso_file_name, :string
    add_column :products, :iso_content_type, :string
    add_column :products, :iso_file_size, :integer
    add_column :products, :iso_updated_at, :datetime
  end

  def self.down
    remove_column :products, :iso_updated_at
    remove_column :products, :iso_file_size
    remove_column :products, :iso_content_type
    remove_column :products, :iso_file_name
  end
end

