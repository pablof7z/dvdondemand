class AddBioToPublishers < ActiveRecord::Migration
  def self.up
    add_column :publishers, :nickname, :string
    add_column :publishers, :bio, :text
  end

  def self.down
    remove_column :publishers, :bio
    remove_column :publishers, :nickname
  end
end
