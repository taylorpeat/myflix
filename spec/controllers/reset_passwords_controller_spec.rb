require 'spec_helper'

describe ResetPasswordsController do
  describe "GET show" do
    it "assigns token" do
      user = Fabricate(:user)
      user.generate_token
      get :show, id: user.token
      expect(assigns(@token)[:token]).to eq(user.token)
    end

    it "redirects to invalid token page if expired token" do
      user = Fabricate(:user)
      get :show, id: "12345"
      expect(response).to redirect_to expired_token_path
    end
  end

  describe "POST create" do
    context "valid password" do
      let(:user) { Fabricate(:user, password: "password") }
      before do
        user.generate_token
        post :create, password: "another_password", token: user.token
      end

      it "resets user password" do
        expect(user.reload.authenticate("another_password")).to eq(user)
      end

      it "deletes user token" do
        expect(user.reload.token).to be_nil
      end

      it "redirects to log in page" do
        expect(response).to redirect_to sign_in_path
      end

      it "displays success message" do
        expect(flash[:success]).to be_present
      end
    end

    context "blank password" do
      let(:user) { Fabricate(:user, password: "password") }

      before do
        user.generate_token
        post :create, password: "", token: user.token
      end

      it "redirects to reset password page if password blank" do
        expect(response).to redirect_to reset_password_path(user.token)
      end

      it "diplays error message" do
        expect(flash[:error]).to eq("Password cannot be blank.")
      end
    end
  end
end 