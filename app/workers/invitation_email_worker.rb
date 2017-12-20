class InvitationEmailWorker
  include Sidekiq::Worker

  def perform(invitation_id, user_id)
    current_user = User.find(user_id)
    invitation = Invitation.find(invitation_id)
    AppMailer.send_invitation_email(invitation, current_user).deliver
  end
end