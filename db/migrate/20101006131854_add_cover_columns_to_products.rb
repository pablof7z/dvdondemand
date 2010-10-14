class AddCoverColumnsToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :cover_file_name, :string
    add_column :products, :cover_content_type, :string
    add_column :products, :cover_file_size, :integer
    add_column :products, :cover_updated_at, :datetime
  end

  def self.down
    remove_column :products, :cover_updated_at
    remove_column :products, :cover_file_size
    remove_column :products, :cover_content_type
    remove_column :products, :cover_file_name
  end
end
