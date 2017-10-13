require 'spec_helper'

describe SessionsController do
  describe "GET new" do
    it "redirects to home if logged in" do
      session[:user_id] = Fabricate(:user).id
      get :new
      expect(response).to redirect_to home_path
    end
    it "doesn't redirect to home if not logged in" do
      get :new
      expect(response).not_to redirect_to home_path
    end
  end
  describe "POST create" do
    context "valid credentials" do
      before do
        @user = Fabricate(:user)
        post :create, email: @user.email, password: @user.password
      end
      it "creates session for user" do
        expect(session[:user_id]).to eq(@user.id)
      end
      it "redirects to home"
      it "sets the notice"
    end

    context "invalid credentials" do
    end
  end
  describe "POST destroy" do
  end
end