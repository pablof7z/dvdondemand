require 'test_helper'

class GenreTest < ActiveSupport::TestCase
  test "should pass some validations before saving" do
    genre = Genre.new
    assert !genre.valid?
  end
end

