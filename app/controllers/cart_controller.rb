class CartController < ApplicationController
  before_action :no_admin, only: :show


  def add_item
    item = Item.find(params[:item_id])
    cart.add_item(item.id.to_s)
    flash[:success] = "#{item.name} was successfully added to your cart"
    redirect_to "/items"
  end

  def show
    @items = cart.items
  end

  def empty
    session.delete(:cart)
    redirect_to '/cart'
  end

  def remove_item
    session[:cart].delete(params[:item_id])
    redirect_to '/cart'
  end

  def increment_item
    item = Item.find(params[:item_id])
    if cart.contents[item.id.to_s] < item.inventory
      cart.add_item(item.id.to_s)
      redirect_to '/cart'
    else
      flash[:error] = "Quantity cannot exceed item inventory"
      redirect_to '/cart'
    end
  end

  def decrement_item
    item = Item.find(params[:item_id])
    cart.subtract_item(item.id.to_s)
    if cart.contents[item.id.to_s].zero?
      session[:cart].delete(params[:item_id])
    end
    redirect_to '/cart'
  end
end
