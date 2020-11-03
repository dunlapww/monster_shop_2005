class Merchant::ItemsController < ItemsController
  def index
    @items = User.find(session[:user_id]).merchant.items
    @merchant = User.find(session[:user_id]).merchant
  end

  def update
    item = Item.find(params[:id])
    if params[:change_active?]
      item.toggle!(:active?)
      flash[:sucess] = item.active? ? "#{item.name} is now available for sale" : "#{item.name} is no longer available for sale"
      redirect_to '/merchant/items'
    end
  end

  def destroy
    item = Item.find(params[:id])
    item.destroy
    flash[:success] = "Item #{item.id} Deleted"
    redirect_to '/merchant/items'
  end
end
