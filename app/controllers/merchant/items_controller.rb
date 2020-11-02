class Merchant::ItemsController < ApplicationController
  def index
    @items = User.find(session[:user_id]).merchant.items
  end
end
