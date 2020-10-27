class UsersController < ApplicationController
  def new

  end

  def create
    new_user = User.new(user_params)
    flash[:success] = "Thank you for logging in #{new_user.name}"
    new_user.save
    session[:user_id] = new_user.id

    redirect_to "/profile"
  end

  def show
    @user = User.find(session[:user_id])
  end

  private
  def user_params
    params.permit(:name, :address, :city, :state, :zip, :email_address, :password)
  end
end
