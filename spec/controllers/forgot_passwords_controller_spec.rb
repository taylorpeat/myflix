require 'spec_helper'

describe ForgotPasswordsController do
  describe "POST create" do
    context "with valid email" do
      after { ActionMailer::Base.deliveries = [] }

      it "redirects to forgot password confirmation" do
        user = Fabricate(:user)
        post :create, email: user.email
        expect(response).to redirect_to forgot_password_confirmation_path
      end

      it "sends email" do
        user = Fabricate(:user)
        post :create, email: user.email
        expect(ActionMailer::Base.deliveries.first.to).to eq([user.email])
      end

      it "creates user token" do
        user = Fabricate(:user)
        post :create, email: user.email
        expect(user.reload.token).to be_present
      end
    end

    context "with invalid email" do
      it "redirects to forgot password page" do
        post :create, email: "wrong_email@example.com"
        expect(response).to redirect_to forgot_password_path
      end
      
      it "displays error message" do
        post :create, email: "wrong_email@example.com"
        expect(flash[:error]).to eq("That email address was not found.")
      end
    end

    context "with blank input" do
      it "redirects to forgot password page" do
        post :create, email: ""
        expect(response).to redirect_to forgot_password_path
      end

      it "displays error message" do
        post :create, email: ""
        expect(flash[:error]).to eq("The email address cannot be blank.")
      end
    end
  end
end 