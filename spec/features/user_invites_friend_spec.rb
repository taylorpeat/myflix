require 'spec_helper'

feature 'User invites friend' do
  scenario 'User successfully invites friend and invitation is accepted', { js: true, vcr: true } do
    user1 = Fabricate(:user)
    sign_in_user(user1)

    invite_a_friend

    friend_accepts_invitation

    friend_should_follow_inviter(user1)
    
    inviter_should_follow_invitee(user1)

    clear_email
  end

  def invite_a_friend
    visit new_invitation_path
    fill_in "Friend's Name", with: "Bob Loblaw"
    fill_in "Friend's Email Address", with: "bob@example.com"
    fill_in "Message", with: "Hello please join this site."
    click_button "Send Invitation"
    sign_out_user
  end

  def friend_accepts_invitation
    open_email "bob@example.com"
    current_email.click_link "Accept the invitation"
    fill_in "Password", with: "password"
    within_frame(find('#card-element iframe')) do
      find_field('cardnumber').set("4242424242424242")
      find_field('exp-date').set("‎01 / 22")
      find_field('cvc').set("‎123")
      find_field('postal').set("‎12345")
    end
    click_button "Sign Up"
  end

  def friend_should_follow_inviter(inviter)
    click_link "People"
    expect(page).to have_content inviter.full_name
    sign_out_user
  end

  def inviter_should_follow_invitee(inviter)
    sign_in_user(inviter)
    click_link "People"
    expect(page).to have_content "Bob Loblaw"
  end
end