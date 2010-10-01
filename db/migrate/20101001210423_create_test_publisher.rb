class CreateTestPublisher < ActiveRecord::Migration
  def self.up
    Publisher.create(
      :id => '1',
      :first_name => 'John',
      :last_name => 'Foobar',
      :email => 'john@foo.bar',
      :address => 'North of the border',
      :approved => true
    )
  end

  def self.down
    Publisher.find(1).destroy
  end
end
