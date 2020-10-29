class PasswordsController < ApplicationController
  def edit
    @user = User.find(session[:user_id])
  end

  def update
    @user = User.find(session[:user_id])
    if @user.update(password_params)
      flash[:success] = "Your password has been updated"
      redirect_to '/profile'
    else
      flash[:error] = @user.errors.full_messages.to_sentence
      render :edit
    end
  end

  private

  def password_params
    params[:user].permit(:password, :password_confirmation)
  end
end
