class AppMailer < ActionMailer::Base
  def send_welcome_email(user)
    @user = user
    mail to: @user.email, from: "info@myflix.com", subject: "Welcome to Myflix!"
  end

  def send_password_reset_email(user)
    @token = user.token
    mail to: user.email, from: "info@myflix.com", subject: "MyFlix Password Reset"
  end

  def send_invitation_email(invitation, user)
    @token = invitation.token
    @user = user
    mail to: invitation.recipient_email, from: "info@myflix.com", subject: "Invitation to MyFlix"
  end
end