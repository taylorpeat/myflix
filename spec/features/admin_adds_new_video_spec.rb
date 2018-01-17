require 'spec_helper'

feature "admin adds new video" do
  scenario "user adds and reorders videos in the queue" do
    admin = Fabricate(:admin)
    Fabricate(:category, name: "Reality")
    
    sign_in_user(admin)

    visit new_admin_video_path

    fill_in "Title", with: "Real Show"
    select "Reality", from: "Category"
    fill_in "Description", with: "It's very real."
    attach_file "Large Cover", "spec/support/uploads/monk_large.jpg"
    attach_file "Small Cover", "spec/support/uploads/monk.jpg"
    fill_in "Video URL", with: "http://www.example.com/video.mp4"
    click_on("Add Video")

    expect(page).to have_content("Real Show, was successfully created.")

    sign_out_user
    sign_in_user

    visit video_path(Video.first)

    expect(page).to have_content("Real Show")
    expect(page).to have_selector(:css, 'video[poster$="monk_large.jpg"]')
    expect(page).to have_selector(:css, 'a[href="http://www.example.com/video.mp4"]')
  end
end

# def expect_new_queue_item_on_my_queue_page(video)
#   page.should have_selector(:link_or_button, 'Update Instant Queue')
#   page.should have_content(video.title.titleize)
# end

# def expect_queue_item_link_to_show_video_page(video)
#   click_link video.title.titleize
#   page.should have_content(video.description)
#   page.should_not have_content("+ My Queue")
# end

# def update_queue
#   click_button "Update Instant Queue"
# end

# def add_video_to_queue(video)
#   visit video_path(video)
#   click_link "+ My Queue"
# end

# def set_queue_item_position(video, position)
#   find("input[data-video-id='#{video.id}']").set(position)
# end

# def expect_video_position(video, position)
#   expect(find("input[data-video-id='#{video.id}']").value).to eq(position.to_s)
# end