class SessionsController < ApplicationController
  def new
    if current_user
      redirect_to '/profile' if current_user.role == "default"
      redirect_to '/merchant' if current_user.role == "merchant_employee"
      redirect_to '/admin' if current_user.role == "admin"
    end
  end

  def create
    user = User.find_by(email_address: params[:email_address])
    if !user.nil? && user.authenticate(params[:password])
      session[:user_id]=user.id
      flash[:success] = "Thank you for logging in #{user.name}"
      redirect_to '/profile' if user.role == "default"
      redirect_to '/merchant' if user.role == "merchant_employee"
      redirect_to '/admin' if user.role == "admin"
    else
      flash.now[:error] = "Invalid credentials, please try again"
      render :new
    end
  end

  def destroy
    require 'pry'; binding.pry
    session[:user_id] = nil
    session[:cart] = Hash.new
    @current_user = nil
    flash.now[:success] = 'You have successfully logged out!'
    redirect_to '/'    
  end
end
