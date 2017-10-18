class AddVideoReferencesToReviews < ActiveRecord::Migration
  def change
    add_reference :reviews, :video, foreign_key: true
  end
end
