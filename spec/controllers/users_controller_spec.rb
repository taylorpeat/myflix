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
    
    context "email sending" do
      after { ActionMailer::Base.deliveries.clear }
      
      it "sends out the email" do
        user_attributes = Fabricate.attributes_for(:user)
        post :create, user: user_attributes
        expect(ActionMailer::Base.deliveries).not_to be_empty
      end

      it "sends the email to the correct user" do
        user_attributes = Fabricate.attributes_for(:user)
        post :create, user: user_attributes
        email = ActionMailer::Base.deliveries.last 
        expect(email.to).to eq([user_attributes["email"]])
      end

      it "has the right content" do
        user_attributes = Fabricate.attributes_for(:user)
        post :create, user: user_attributes
        email = ActionMailer::Base.deliveries.last 
        expect(email.body).to include(user_attributes["full_name"])
      end

      it "does not send email with invalid inputs" do
        post :create, user: {full_name: "Joe Schmoe", email: "j@s.com", password: "" }
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end
end