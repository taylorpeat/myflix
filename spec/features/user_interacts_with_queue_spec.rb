require 'spec_helper'

feature "user interacts with the queue" do
  scenario "user adds and reorders videos in the queue" do
    user = Fabricate(:user)
    sign_in_user(user)
    video = Fabricate(:video)
    visit video_path(video)
    click_link "+ My Queue"
    page.should have_selector(:link_or_button, 'Update Instant Queue')
    page.should have_content(video.title.titleize)

  end
end