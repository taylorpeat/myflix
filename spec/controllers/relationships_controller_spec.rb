require 'spec_helper'

describe RelationshipsController do
  describe "GET index" do
    it "assigns instance variable of current user relationships" do
      user1 = Fabricate(:user)
      user2 = Fabricate(:user)
      relationship = Fabricate(:relationship, follower_id: user1.id, leader_id: user2.id)
      set_current_user(user1)

      get :index
      expect(assigns(:relationships)).to eq([relationship])
    end
  end
end