class AdminController < ApplicationController
  before_action :require_admin

  def show
    @orders = Order.status_sort
  end

  private

  def require_admin
    render file: "/public/404" unless current_admin?
  end
end
