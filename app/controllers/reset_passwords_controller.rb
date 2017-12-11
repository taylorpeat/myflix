class ResetPasswordsController < ApplicationController
  def show
    @token = params[:id]
  end

  def create
    user = User.find_by(token: params["token"])
    user.password = params["password"]
    if user.password.blank?
      flash[:error] = "Password cannot be blank."
      redirect_to reset_password_path(user.token)
    else
      user.token = nil
      user.save
      flash[:success] = "You have successfully reset your password!"
      redirect_to sign_in_path
    end
  end
end