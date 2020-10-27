class UsersController < ApplicationController
  def new

  end

  def create
    if User.email_nil?(params[:email_address])
      new_user = User.new(user_params)
      if new_user.save
        flash[:success] = "Thank you for logging in #{new_user.name}"
        session[:user_id] = new_user.id
        redirect_to "/profile"
      else
        flash[:error] = "User not created, missing required field inputs"
        redirect_to '/register'
      end
    else
      flash[:error] = "E-mail already taken, please input another!"
      render :new
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
