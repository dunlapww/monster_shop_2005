class ItemOrdersController < ApplicationController

  def update
    @item_order = ItemOrder.find(params[:id])
    @item_order.update(status: 'fulfilled')
    @item_order.order.package
    flash[:success] = "Item Order Fulfilled!"
    current_inventory = @item_order.item.inventory
    @item_order.item.update(inventory: current_inventory - @item_order.quantity)
    redirect_to "/merchant/orders/#{@item_order.order.id}"
  end
end
