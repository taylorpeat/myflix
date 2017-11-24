require 'spec_helper'

describe User do
  it { should have_many(:queue_items).order(:position)}
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }

  describe "#queued_video?" do
    it "returns true if video exists in queue" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      queue_item = Fabricate(:queue_item, video: video, user: user)
      expect(user.queued_video?(video)).to eq(true)
    end

    it "returns false if video does not exist in queue" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      video2 = Fabricate(:video)
      queue_item = Fabricate(:queue_item, video: video2, user: user)
      expect(user.queued_video?(video)).to eq(false)
    end
  end
end
