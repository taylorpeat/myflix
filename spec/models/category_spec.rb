require 'spec_helper'

describe Category do
  it { should have_many(:videos).order("created_at DESC") }

  describe "#recent_videos" do

    it "returns empty array if no match" do
      comedy = Category.create(name: 'comedy', title: "TV Comedies")
      
      expect(comedy.recent_videos).to eq([])
    end

    it "returns empty array if all videos in different categories" do
      comedy = Category.create(name: 'comedy', title: "TV Comedies")
      futurama = Video.create(title: 'futurama', description: "space travel", category_id: 0)
      
      expect(comedy.recent_videos).to eq([])
    end

    it "returns an array of one for a single match" do
      comedy = Category.create(name: 'comedy', title: "TV Comedies")
      futurama = Video.create(title: 'futurama', description: "space travel", category_id: nil)
      south_park = Video.create(title: 'south_park', description: "rude", category_id: comedy.id)
      monk = Video.create(title: 'monk', description: "detective story", category_id: nil)
      
      expect(comedy.recent_videos).to eq([south_park])
    end

    it "returns all matches ordered by created_at" do
      comedy = Category.create(name: 'comedy', title: "TV Comedies")
      futurama = Video.create(title: 'futurama', description: "space travel", category_id: nil)
      south_park = Video.create(title: 'south_park', description: "rude", category_id: comedy.id)
      monk = Video.create(title: 'monk', description: "detective story", category_id: comedy.id, created_at: 1.day.ago)
      
      expect(comedy.recent_videos).to eq([south_park, monk])
    end

    it "returns all matches if there are less than 6 videos" do
      comedy = Category.create(name: 'comedy', title: "TV Comedies")
      futurama = Video.create(title: 'futurama', description: "space travel", category_id: nil)
      south_park = Video.create(title: 'south_park', description: "rude", category_id: comedy.id)
      monk = Video.create(title: 'monk', description: "detective story", category_id: comedy.id, created_at: 1.day.ago)
      vid_three = Video.create(title: '3', description: "3", category_id: comedy.id, created_at: 2.day.ago)
      vid_four = Video.create(title: '4', description: "4", category_id: comedy.id, created_at: 3.day.ago)
      vid_five = Video.create(title: '5', description: "5", category_id: comedy.id, created_at: 4.day.ago)
      vid_six = Video.create(title: '6', description: "6", category_id: comedy.id, created_at: 5.day.ago)

      expect(comedy.recent_videos.count).to eq(6)
    end

    it "returns the most recent 6 videos" do
      comedy = Category.create(name: 'comedy', title: "TV Comedies")
      futurama = Video.create(title: 'futurama', description: "space travel", category_id: nil)
      south_park = Video.create(title: 'south_park', description: "rude", category_id: comedy.id)
      monk = Video.create(title: 'monk', description: "detective story", category_id: comedy.id, created_at: 1.day.ago)
      vid_three = Video.create(title: '3', description: "3", category_id: comedy.id, created_at: 2.day.ago)
      vid_four = Video.create(title: '4', description: "4", category_id: comedy.id, created_at: 3.day.ago)
      vid_five = Video.create(title: '5', description: "5", category_id: comedy.id, created_at: 4.day.ago)
      vid_six = Video.create(title: '6', description: "6", category_id: comedy.id, created_at: 5.day.ago)
      vid_seven = Video.create(title: '7', description: "7", category_id: comedy.id, created_at: 6.day.ago) 

      expect(comedy.recent_videos).to eq([south_park, monk, vid_three, vid_four, vid_five, vid_six])
    end
  end
end