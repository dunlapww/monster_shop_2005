class UsersController < ApplicationController
  before_action :current_user?

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Thank you for logging in #{@user.name}"
      session[:user_id] = @user.id
      redirect_to "/profile"
    else
      flash.now[:error] = @user.errors.full_messages.to_sentence
      @user.email_address=nil
      render action: "new"
    end
  end

  def show
    @user = User.find(session[:user_id])
  end

  private
  def user_params
    params[:user].permit(:name, :address, :city, :state, :zip, :email_address, :password, :password_confirmation)
  end
end
