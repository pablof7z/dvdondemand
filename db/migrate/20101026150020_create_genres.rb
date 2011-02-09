class CreateGenres < ActiveRecord::Migration
  def self.up
    create_table :genres do |t|
      t.references :media_type
      t.string :title
    end
  end

  def self.down
    drop_table :genres
  end
end

