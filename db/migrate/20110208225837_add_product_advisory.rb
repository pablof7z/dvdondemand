class AddProductAdvisory < ActiveRecord::Migration
  def self.up
    add_column :products, :advisory_violence, :boolean, :default => false
    add_column :products, :advisory_nudity, :boolean, :default => false
    add_column :products, :advisory_language, :boolean, :default => false
  end

  def self.down
    remove_column :products, :advisory_violence
    remove_column :products, :advisory_nudity
    remove_column :products, :advisory_language
  end
end
