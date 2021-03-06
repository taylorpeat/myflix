require 'spec_helper'

describe SessionsController do
  describe "GET new" do  
    it "redirects to home if logged in" do
      set_current_user
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
      let(:user) { Fabricate(:user) }

      before do
        post :create, email: user.email, password: user.password
      end
      
      it "creates session for user" do
        expect(session[:user_id]).to eq(user.id)
      end
      
      it "redirects to home" do
        expect(response).to redirect_to home_path
      end
      
      it "sets the notice" do
        expect(flash[:notice]).to be_present
      end
    end

    context "invalid credentials" do
      before do
        post :create, email: nil, password: "password"
      end
      
      it "does not create session" do
        expect(session[:user_id]).to be_nil
      end
      
      it "sets the error message" do
        expect(flash[:error]).to be_present
      end
      
      it "redirects to the sign in page" do
        expect(response).to redirect_to sign_in_path
      end
    end
  end
  
  describe "GET destroy" do
    before do
      set_current_user
      get :destroy
    end
    
    it "clears the session for the user" do
      expect(session[:user_id]).to be_nil
    end

    it "redirects to root" do
      expect(response).to redirect_to root_path
    end
    
    it "sets flash notice" do
      expect(flash[:notice]).to eq("You have signed out.")
    end
  end
end