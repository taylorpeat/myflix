class ForgotPasswordsController < ApplicationController
  def create
    @user = User.find_by(email: params[:email])
    
    if @user
      @user.generate_token
      AppMailer.send_password_reset_email(@user).deliver
      redirect_to forgot_password_confirmation_path
    else
      if params[:email].blank?
        flash[:error] = "The email address cannot be blank."
      else
        flash[:error] = "That email address was not found."
      end
      redirect_to forgot_password_path
    end
  end
end 