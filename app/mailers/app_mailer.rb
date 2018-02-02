class AppMailer < ActionMailer::Base
  def send_welcome_email(user)
    @user = user
    mail to: select_email, from: "info@myflix.com", subject: "Welcome to Myflix!"
  end

  def send_password_reset_email(user)
    @user = user
    @token = user.token
    mail to: select_email, from: "info@myflix.com", subject: "MyFlix Password Reset"
  end

  def send_invitation_email(invitation, user)
    @invitation = invitation
    @user = user
    mail to: select_email(@invitation), from: "info@myflix.com", subject: "Invitation to MyFlix"
  end

  private

  def select_email(invitation=nil)
    return "taylorpeat@hotmail.com" if Rails.env.staging?
    return invitation.recipient_email if invitation
    @user.email
  end
end