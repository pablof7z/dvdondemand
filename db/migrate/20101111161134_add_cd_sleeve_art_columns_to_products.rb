class AddCdSleeveArtColumnsToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :cd_sleeve_art_file_name,    :string
    add_column :products, :cd_sleeve_art_content_type, :string
    add_column :products, :cd_sleeve_art_file_size,    :integer
    add_column :products, :cd_sleeve_art_updated_at,   :datetime
  end

  def self.down
    remove_column :products, :cd_sleeve_art_updated_at
    remove_column :products, :cd_sleeve_art_file_size
    remove_column :products, :cd_sleeve_art_content_type
    remove_column :products, :cd_sleeve_art_file_name
  end
end

