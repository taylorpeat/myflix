require 'spec_helper'

feature "user resets password" do
  scenario "successfully resets password" do
    user = Fabricate(:user)

    visit sign_in_path
    click_link "Forgot Password?"

    fill_in "email", with: user.email
    click_button "Send Email"
    expect(page).to have_content("We have sent an email")

    open_email(user.email)
    current_email.click_link("Reset password")

    fill_in "password", with: "password"
    click_button "Reset Password"
    expect(page).to have_content "Sign in"

    fill_in "email", with: user.email
    fill_in "password", with: "password"
    click_button "Sign in"
    expect(page).to have_content("Welcome, #{user.full_name}")

    clear_mail
  end
end