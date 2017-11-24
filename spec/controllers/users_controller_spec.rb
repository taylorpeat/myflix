require 'spec_helper'

describe UsersController do
  describe "GET new" do
    it "assigns user instance variable" do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end
  end

  describe "POST create" do
    context "with valid input" do
      before do 
        post :create, user: Fabricate.attributes_for(:user)
      end
      
      it "creates new user" do
        expect(User.count).to eq(1)
      end
      
      it "redirects to videos" do
        expect(response).to redirect_to videos_path
      end
    end
    
    context "with invalid input" do
      before do
        post :create, user: { password: "password", full_name: "Taylor Peat" }
      end
      
      it "renders new template" do
        expect(response).to render_template :new
      end
      
      it "assigns new user" do
        expect(assigns(:user)).to be_instance_of(User)
      end
    end
  end
end