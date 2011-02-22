class AddFeaturedToProduct < ActiveRecord::Migration
  def self.up
    add_column :products, :featured, :integer
  end

  def self.down
    remove_column :products, :featured
  end
end
