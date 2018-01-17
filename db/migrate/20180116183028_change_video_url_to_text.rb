class ChangeVideoUrlToText < ActiveRecord::Migration
  def self.up
    change_column :videos, :video_url, :text
  end

  def self.down
    change_column :videos, :video_url, :string
  end
end
