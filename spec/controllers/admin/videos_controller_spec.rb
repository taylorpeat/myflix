require 'spec_helper'

describe Admin::VideosController do
  describe "GET new" do
    it_behaves_like "require_sign_in" do
      let(:action) { get :new }
    end
    
    it_behaves_like "require_admin" do
      let(:action) { get :new }
    end

    it "sets @video instance variable" do
      set_current_admin
      get :new
      expect(assigns(:video)).to be_instance_of(Video)
      expect(assigns(:video)).to be_new_record
    end
    
    it "displays error message if not admin" do
      set_current_user
      get :new
      expect(flash[:notice]).to be_present
    end
  end

  describe "POST create" do
    it_behaves_like "require_admin" do
      let(:action) { get :new }
    end

    context "with valid inputs" do
      let(:category) { Fabricate(:category) }
      
      before do
        set_current_admin
        post :create, video: { title: "Star Wars", category_id: category.id, description: "Space fighting." }
      end

      it "creates a new video" do
        expect(Video.count).to eq(1)
      end

      it "redirects to new video page" do
        expect(response).to redirect_to new_admin_video_path
      end

      it "displays success message" do
        expect(flash[:success]).to be_present
      end
    end

    context "with invalid inputs" do
      let(:category) { Fabricate(:category) }

      before do
        set_current_admin
        post :create, video: { title: "", category_id: category.id, description: "Space fighting." }
      end

      it "doesn't create a new video" do
        expect(Video.count).to eq(0)
      end

      it "renders new page" do
        expect(response).to render_template :new
      end

      it "creates video instance variable" do
        expect(assigns(:video)).to be_instance_of(Video)
      end
      
      it "displays error message" do
        expect(flash[:error]).to be_present
      end
    end

  end
end 