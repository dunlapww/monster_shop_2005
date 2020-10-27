class UsersController < ApplicationController
  def new

  end

  def create
    user = User.new(user_params)
    flash[:success] = "Thank you for logging in #{user.name}"
    user.save

    redirect_to "/profile"
  end

  private
  def user_params
    params.permit(:name, :address, :city, :state, :zip, :email_address, :password)
  end
end
