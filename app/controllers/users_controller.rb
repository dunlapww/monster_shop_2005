class UsersController < ApplicationController
  def new

  end

  def create
    new_user = User.new(user_params)
    if new_user.save
      flash[:success] = "Thank you for logging in #{new_user.name}"
      session[:user_id] = new_user.id
      redirect_to "/profile"
    else
      flash[:error] = "User not created, missing required field inputs"
      redirect_to '/register'
    end
  end

  def show
    @user = User.find(session[:user_id])
  end

  private
  def user_params
    params.permit(:name, :address, :city, :state, :zip, :email_address, :password, :password_confirmation)
  end
end
