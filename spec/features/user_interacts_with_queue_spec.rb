require 'spec_helper'

feature "user interacts with the queue" do
  scenario "user adds and reorders videos in the queue" do
    user = Fabricate(:user)
    video = Fabricate(:video)
    video2 = Fabricate(:video)
    
    sign_in_user(user)

    add_video_to_queue(video)

    expect_new_queue_item_on_my_queue_page(video)
    expect_queue_item_link_to_show_video_page(video)
    
    add_video_to_queue(video2)

    set_queue_item_position(video, 2)
    set_queue_item_position(video2, 1)
    
    update_queue
    
    expect_video_position(video, 2)
    expect_video_position(video2, 1)
  end
end

def expect_new_queue_item_on_my_queue_page(video)
  page.should have_selector(:link_or_button, 'Update Instant Queue')
  page.should have_content(video.title.titleize)
end

def expect_queue_item_link_to_show_video_page(video)
  click_link video.title.titleize
  page.should have_content(video.description)
  page.should_not have_content("+ My Queue")
end

def update_queue
  click_button "Update Instant Queue"
end

def add_video_to_queue(video)
  visit video_path(video)
  click_link "+ My Queue"
end

def set_queue_item_position(video, position)
  find("input[data-video-id='#{video.id}']").set(position)
end

def expect_video_position(video, position)
  expect(find("input[data-video-id='#{video.id}']").value).to eq(position.to_s)
end