class PasswordResetEmailWorker
  include Sidekiq::Worker

  def perform(user_id)
    user = User.find(user_id)
    AppMailer.send_password_reset_email(user).deliver
  end
end