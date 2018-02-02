require 'spec_helper'

describe UsersController do
  describe "GET new" do
    it "assigns user instance variable" do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end
  end

  describe "GET new_with_token" do
    let(:invitation) { Fabricate(:invitation) }

    before do
      get :new_with_token, token: invitation.token
    end

    it "assigns user instance variable" do
      expect(assigns(:user)).to be_instance_of(User)
    end

    it "assigns invitee email instance variable" do
      expect(assigns(:user).email).to eq(invitation.recipient_email)
    end

    it "assigns invitee name to instance variable" do
      expect(assigns(:user).full_name).to eq(invitation.recipient_name)
    end

    it "assigns invitation token instance variable" do
      expect(assigns(:invitation_token)).to eq(invitation.token)
    end
  end

  describe "POST create" do
    after { ActionMailer::Base.deliveries.clear }
    before do
      response = double
      response.stub(:successful?) { true }
      StripeWrapper::Charge.stub(:create) { response }
    end
    
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

    context "with valid input and invitation token" do
      let(:inviter) { Fabricate(:user) }
      
      before do
        invitation = Fabricate(:invitation, inviter_id: inviter.id)
        post :create, user: Fabricate.attributes_for(:user), invitation_token: invitation.token
      end

      it "creates new user" do
        expect(User.count).to eq(2)
      end

      it "creates new friendship with invitee" do
        expect(User.last.follows?(inviter)).to eq(true)
      end
    end

    context "with invalid input and invitation token" do
      let(:inviter) { Fabricate(:user) }
      let(:invitation) { Fabricate(:invitation, inviter_id: inviter.id) }
      
      before do
        post :create, user: Fabricate.attributes_for(:user).merge(full_name: ""), invitation_token: invitation.token
      end

      it "does not create new user" do
        expect(User.count).to eq(1)
      end

      it "doesn't creates new friendship with invitee" do
        expect(User.last.follows?(inviter)).to eq(false)
      end

      it "assigns invitation token" do
        expect(assigns(:invitation_token)).to eq(invitation.token)
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

      it "doesn't create new user" do
        expect(User.count).to eq(0)
      end
    end
    
    context "email sending" do
      it "sends out the email" do
        user_attributes = Fabricate.attributes_for(:user)
        post :create, user: user_attributes
        expect(ActionMailer::Base.deliveries).not_to be_empty
      end

      it "sends the email to the correct user" do
        user_attributes = Fabricate.attributes_for(:user)
        post :create, user: user_attributes
        email = ActionMailer::Base.deliveries.first 
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