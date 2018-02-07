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
    @invitation_token = params[:invitation_token]
    Stripe.api_key = ENV["stripe_api_key"]
    
    if @user.valid?
      token = params[:stripeToken]

      response = StripeWrapper::Charge.create( amount: 999, desciption: "Registration fee for #{@user.email}", source: token)
      response.status == "succeeded" ? handle_success : handle_error(response)
    else
      handle_error
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :full_name, :password)
  end

  def handle_invitation
    invitation = Invitation.find_by(token: params[:invitation_token]) 

    if invitation
      inviter = User.find(invitation.inviter_id)
      @user.follow(inviter)
      inviter.follow(@user)
    end
  end

  def handle_success
    @user.save
    WelcomeEmailWorker.perform_async(@user.id)
    handle_invitation
    session[:user_id] = @user.id
    flash[:success] = "Your account has been created."
    redirect_to videos_path
  end

  def handle_error(response=nil)
    flash[:error] = "The account could not be created"
    flash[:error] += "because #{response.error_message}" if response
    render :new
  end
end