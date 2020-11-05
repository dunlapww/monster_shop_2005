class Admin::OrdersController < ApplicationController
  before_action :require_admin

  def index
    @user = User.find(params[:user_id])
  end

  def update
    order = Order.find(params[:id])
    order.update(status: "shipped")
    redirect_to "/admin"
  end
end
