class CreateCatalogs < ActiveRecord::Migration
  def self.up
    create_table :catalogs do |t|
      t.string :title
      t.text :description
      t.references :publisher
      t.timestamps
    end
  end

  def self.down
    drop_table :catalogs
  end
end
