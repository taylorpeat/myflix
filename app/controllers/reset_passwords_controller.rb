class ResetPasswordsController < ApplicationController
  def show
    @token = params[:id]
  end

  def create
    user = User.find_by(token: params["token"])
    user.password = params["password"]
    user.save
    redirect_to sign_in_path
  end
end