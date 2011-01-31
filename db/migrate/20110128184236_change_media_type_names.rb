class ChangeMediaTypeNames < ActiveRecord::Migration
  class MediaType < ActiveRecord::Base; end

  Names = { 'CD' => 'Music', 'DVD' => 'Movie' }

  def self.up
    Names.each do |old, new|
      media_type = MediaType.find_by_name(old)
      media_type.name = new
      media_type.save!
    end
  end

  def self.down
    Names.each do |new, old|
      media_type = MediaType.find_by_name(old)
      media_type.name = new
      media_type.save!
    end
  end
end
