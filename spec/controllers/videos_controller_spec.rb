require 'spec_helper'

describe VideosController do
  describe "GET show" do
    it "sets @video for authenticated user" do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      get :show, id: video.id
      expect(assigns(:video)).to eq(video)
    end
    it "redirects unauthenticated user to the sign in page" do
      video = Fabricate(:video)
      get :show, id: video.id
      expect(response).to redirect_to sign_in_path
    end
  end

  describe "POST search" do
    it "sets @results for authenticated users" do
      session[:user_id] = Fabricate(:user).id
      futurama = Fabricate(:video, title: "futurama")
      back_to_the_future = Fabricate(:video, title: "back to the future")
      superman = Fabricate(:video, title: "superman")
      post :search, query: 'futur'
      expect(assigns(:videos)).to eq([futurama, back_to_the_future])
    end
    it "redirects to sign in page for the unauthenticated users" do
      post :search, query: 'futur'
      expect(response).to redirect_to sign_in_path
    end
  end
end 