class Profile::OrdersController < ApplicationController
  def index
    @user = User.find(session[:user_id])
    @orders = @user.orders
  end
end
