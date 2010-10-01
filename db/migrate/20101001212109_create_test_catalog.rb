class CreateTestCatalog < ActiveRecord::Migration
  def self.up
    Catalog.create(
      :id => '1',
      :publisher_id => '1',
      :title => 'The Foobar Blues',
      :description => 'Play it again, Sam'
    )
  end

  def self.down
    Catalog.find(1).destroy
  end
end
