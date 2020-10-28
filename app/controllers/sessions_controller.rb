class SessionsController < ApplicationController
  def new
    
  end

  def create
    user = User.find_by(email_address: params[:email_address])
    if user.authenticate(params[:password])
      session[:user_id]=user.id
      flash[:success] = "Thank you for logging in #{user.name}"
      redirect_to '/profile' if user.role == "default"
      redirect_to '/merchant' if user.role == "merchant_employee"
    else
      flash.now[:error] = "Invalid credentials, please try again"
      render :new
    end
  end
end
