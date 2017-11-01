require 'spec_helper'

describe QueueItemsController do
  describe "GET index" do
    let(:video1) { Fabricate(:video) }
    let(:video2) { Fabricate(:video) }
    let(:user) { Fabricate(:user) }

    let(:queue_items) do
      queue_item1 = Fabricate(:queue_item, video_id: video1, user_id: user )
      queue_item2 = Fabricate(:queue_item, video_id: video2, user_id: user )
    end

    context "With authenticated user" do
      before do
        session[:user_id] = user.id
      end

      it "sets @queue_items" do
        expect(:queue_items).to match_array(queue_items)
      end
    end

    context "With unauthenticated user" do
    end
  end
end
