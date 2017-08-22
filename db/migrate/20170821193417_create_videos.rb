class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :cover_image_url
    end
  end
end
