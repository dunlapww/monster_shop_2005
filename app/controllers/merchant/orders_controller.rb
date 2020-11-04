class Merchant::OrdersController < ApplicationController
  
  def show
    @order = Order.find(params[:id])
    @item_orders = @order.merchant_item_orders(current_user[:merchant_id])
  end
end
