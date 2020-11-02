class Merchant::ItemsController < ApplicationController
  def index
    @items = User.find(session[:user_id]).merchant.items
  end

  def update
    item = Item.find(params[:id])
    if params[:change_active?]
      item.toggle!(:active?)
      flash[:sucess] = item.active? ? "#{item.name} is now available for sale" : "#{item.name} is no longer available for sale"
      redirect_to '/merchant/items'
    end
  end
end
