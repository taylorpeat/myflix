def set_current_user(user=Fabricate(:user))
  session[:user_id] = user.id
end

def set_current_admin(user=Fabricate(:admin))
  session[:user_id] = user.id
end


def sign_in_user(user=Fabricate(:user))
  visit sign_in_path
  fill_in "Email Address", with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"
end

def sign_out_user
  visit sign_out_path
end
