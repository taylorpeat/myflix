require 'spec_helper'

describe InvitationsController do
  describe "GET new" do
    it "assigns invitations instance variable" do
      set_current_user
      get :new
      expect(assigns(:invitation)).to be_new_record
      expect(assigns(:invitation)).to be_instance_of(Invitation)
    end

    it_behaves_like "require_sign_in" do
      let(:action) { get :new }
    end
  end

  describe "POST create" do
    context "with valid inputs" do
      after { ActionMailer::Base.deliveries.clear }

      let(:user) { Fabricate(:user) }

      before do
        set_current_user(user)
        post :create, invitation: { recipient_name: "Bill Gates", recipient_email: "bill@example.com", message: "Hey Bill" }
      end

      it "redirects to new invite page" do
        expect(response).to redirect_to new_invitation_path
      end

      it "creates new invite" do
        expect(Invitation.count).to eq(1)
      end

      it "relates new invite to current user" do
        expect(Invitation.first.inviter_id).to eq(user.id)
      end

      it "sends email to invitee" do
        expect(ActionMailer::Base.deliveries.first.to).to eq(["bill@example.com"])
      end

      it "displays success message" do
        expect(flash[:success]).to be_present
      end
    end
    
    context "with invalid inputs" do
      let(:user) { Fabricate(:user) }

      before do
        set_current_user(user)
        post :create, invitation: { recipient_email: "bill@example.com", message: "Hey Bill" }
      end

      it "redirects to new invite page" do
        expect(response).to redirect_to new_invitation_path
      end

      it "displays error message" do
        expect(flash[:error]).to be_present
      end

      it "does not create new invitee" do
        expect(Invitation.count).to eq(0)
      end

      it "does not send email" do
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end

    it_behaves_like "require_sign_in" do
      let(:action) { post :create }
    end
  end
end
