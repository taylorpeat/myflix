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

      begin
        charge = Stripe::Charge.create(
          :amount => 999,
          :currency => "cad",
          :description => "Registration fee for #{@user.email}",
          :source => token,
        )

        handle_success
      rescue Stripe::CardError => e
        @card_error = e.json_body[:error][:message]
        handle_error
      end
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
    else
      session[:user_id] = @user.id
    end
  end

  def handle_success
    @user.save
    WelcomeEmailWorker.perform_async(@user.id)
    session[:user_id] = @user.id
    flash[:success] = "Your account has been created."
    redirect_to videos_path
  end

  def handle_error
    flash[:error] = "The account could not be created."
    render :new
  end
end