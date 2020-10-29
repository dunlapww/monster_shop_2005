class PasswordsController < ApplicationController
  def edit
    @user = User.find(session[:user_id])
  end

  def update
    user = User.find(session[:user_id])
    user.update(password_params)
    flash[:success] = "Your password has been updated"
    redirect_to '/profile'
  end

  private

  def password_params
    params.permit(:password, :password_confirmation)
  end
end
