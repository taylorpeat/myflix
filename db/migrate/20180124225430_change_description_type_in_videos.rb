class ChangeDescriptionTypeInVideos < ActiveRecord::Migration
  def self.up
    change_column :videos, :description, :text
  end
  def self.down
    change_column :videos, :description, :string
  end
end
