class InvitationsController < ApplicationController
  
  before_filter :require_user

  def new
    @invitation = Invitation.new
  end

  def create
    invitation = Invitation.new(invitation_params)
    
    if invitation.save
      AppMailer.send_invitation_email(invitation, current_user).deliver
      flash[:success] = "Your invitation has been sent."
    else
      flash[:error] = "Your invitation could not be sent."
    end

    redirect_to new_invitation_path
  end

  def invitation_params
    params.require(:invitation).permit(:recipient_name, :recipient_email, :message).merge(inviter_id: current_user.id)
  end
end