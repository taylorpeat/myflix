require 'spec_helper'

describe ResetPasswordsController do
  describe "GET show" do
    it "assigns token" do
      user = Fabricate(:user)
      user.generate_token
      get :show, id: user.token
      expect(assigns(@token)[:token]).to eq(user.token)
    end
  end

  describe "POST create" do
    it "resets user password" do
      user = Fabricate(:user, password: "password")
      user.generate_token
      post :create, password: "another_password", token: user.token
      expect(user.reload.authenticate("another_password")).to eq(user)
    end
    
    it "deletes user token"
    it "redirects to log in page"
    it "displays success message"
    it "redirects to reset password page if password blank"
  end
end 