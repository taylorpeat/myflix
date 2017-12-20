class UsersController < ApplicationController
  before_filter :require_not_signed_in, only: [:new, :new_with_token]

  def new
    @user = User.new
  end

  def new_with_token
    invitation = Invitation.find_by(token: params[:token])
    @user = User.new(full_name: invitation.recipient_name, email: invitation.recipient_email)
    @invitation_token = invitation.token
    render :new
  end

  def create
    @user = User.new(user_params)
    invitation = Invitation.find_by(token: params[:invitation_token]) 

    if @user.save
      if invitation
        inviter = User.find(invitation.inviter_id)
        @user.follow(inviter)
        inviter.follow(@user)
      else
        session[:user_id] = @user.id
      end
      
      WelcomeEmailWorker.perform_async(@user.id)
      redirect_to videos_path
    else
      @invitation_token = invitation.token if invitation
      flash[:error] = "The account could not be created."
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :full_name, :password)
  end
end