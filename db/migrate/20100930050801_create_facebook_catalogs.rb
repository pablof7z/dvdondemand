class CreateFacebookCatalogs < ActiveRecord::Migration
  def self.up
    create_table :facebook_catalogs do |t|
      t.integer :catalog_id
      t.string :facebook_secret
      t.string :facebook_data

      t.timestamps
    end
  end

  def self.down
    drop_table :facebook_catalogs
  end
end
