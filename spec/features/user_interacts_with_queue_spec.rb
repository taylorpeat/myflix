require 'spec_helper'

feature "user interacts with the queue" do
  scenario "with valid email and password" do
    video = Fabricate(:video)
    visit video_path(video)
    click_link "+ My Queue"
  end
end