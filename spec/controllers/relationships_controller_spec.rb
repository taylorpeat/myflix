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

    it_behaves_like "require_sign_in" do
      let(:action) { get :index }
    end
  end

  describe "DELETE destroy" do
    it_behaves_like "require_sign_in" do
      let(:action) { delete :destroy, id: 1 }
    end

    it "removes relationship if current user is the follower" do
      user1 = Fabricate(:user)
      user2 = Fabricate(:user)
      relationship = Fabricate(:relationship, follower_id: user1.id, leader_id: user2.id)
      set_current_user(user1)
      delete :destroy, id: relationship
      expect(Relationship.count).to eq(0)
    end

    it "leaves relationship if current user is not the follower" do
      user1 = Fabricate(:user)
      user2 = Fabricate(:user)
      relationship = Fabricate(:relationship, follower_id: user1.id, leader_id: user2.id)
      set_current_user(user2)
      delete :destroy, id: relationship
      expect(Relationship.count).to eq(1)    
    end

    it "redirects to the people page" do
      user1 = Fabricate(:user)
      set_current_user(user1)
      relationship = Fabricate(:relationship, follower_id: user1.id)
      delete :destroy, id: relationship
      expect(response).to redirect_to people_path
    end
  end

  describe "POST create" do
    it_behaves_like "require_sign_in" do
      let(:action) { post :create }
    end

    it "creates new relationship with current_user as follower" do
      user1 = Fabricate(:user)
      user2 = Fabricate(:user)
      set_current_user(user1)
      post :create, leader_id: user2.id
      expect(Relationship.first.follower).to eq(user1)
    end

    it "redirects to people page" do
      user1 = Fabricate(:user)
      user2 = Fabricate(:user)
      set_current_user(user1)
      post :create, leader_id: user2.id
      expect(response).to redirect_to people_path
    end

    it "does not create relationship if not signed in" do
      user1 = Fabricate(:user)
      user2 = Fabricate(:user)
      post :create, leader_id: user2.id
      expect(Relationship.count).to eq(0)    
    end

    it "does not create relationship following self" do
      user1 = Fabricate(:user)
      set_current_user(user1)
      post :create, leader_id: user1.id
      expect(Relationship.count).to eq(0)    
    end

    it "does not create duplicate relationships" do
      user1 = Fabricate(:user)
      user2 = Fabricate(:user)
      set_current_user(user1)
      post :create, leader_id: user2.id
      post :create, leader_id: user2.id
      expect(Relationship.count).to eq(1)
    end
  end
end