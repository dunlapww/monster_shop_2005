class UsersController < ApplicationController
  def new

  end

  def create
    user = User.create(user_params)
    flash[:notice] = "Thank you for logging in #{user.name}"

    redirect_to "/profile"
  end

  private
  def user_params
    params.permit(:name, :address, :city, :state, :zip, :email_address, :password)
  end
end
