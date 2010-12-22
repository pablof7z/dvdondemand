class WholesalerAddColumnApiKey < ActiveRecord::Migration
  def self.up
    add_column :wholesalers, :api_key, :string
  end

  def self.down
    remove_column :wholesalers, :api_key
  end
end
