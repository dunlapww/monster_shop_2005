class AdminController < ApplicationController
  before_action :require_admin

  def show
    @orders = Order.status_sort
  end
end
