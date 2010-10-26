class CreateGenres < ActiveRecord::Migration
  def self.up
    create_table :genres do |t|
      t.string :media
      t.string :title
    end
  end

  def self.down
    drop_table :genres
  end
end

