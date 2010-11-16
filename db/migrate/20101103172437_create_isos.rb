class CreateIsos < ActiveRecord::Migration
  def self.up
    create_table :isos do |t|
      t.references :product
      t.string :iso_file_name
      t.string :iso_content_type
      t.string :iso_file_size

      t.timestamps
    end
  end

  def self.down
    drop_table :isos
  end
end

