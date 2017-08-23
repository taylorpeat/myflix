class AddDetailsToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :title, :string
    add_column :videos, :description, :string
    add_column :videos, :rating, :decimal
  end
end
