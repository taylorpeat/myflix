require 'spec_helper'

feature "user follows" do
  scenario "user follows and unfollows someone" do
    user1 = Fabricate(:user)
    user2 = Fabricate(:user)
    category = Fabricate(:category)
    video = Fabricate(:video, category: category )
    review = Fabricate(:review, user: user2, video: video)

    sign_in_user(user1)

    visit home_path
    find("a[href='/videos/#{video.id}']").click

    click_link user2.full_name

    click_link "Follow"
    expect(page).to have_content(user2.full_name)

    click_link "People"
    expect(page).to have_content(user2.full_name)

    unfollow(user2)
    expect(page).not_to have_content(user2.full_name)

  end

  def unfollow(user)
    find("a[data-method='delete']").click
  end
end