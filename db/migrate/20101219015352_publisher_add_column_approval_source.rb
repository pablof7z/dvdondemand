class PublisherAddColumnApprovalSource < ActiveRecord::Migration
  def self.up
    add_column :publishers, :approval_source, :string
  end

  def self.down
    remove_column :publishers, :approval_source
  end
end
