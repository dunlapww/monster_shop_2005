class Admin::ItemsController < ItemsController
  before_action :require_admin

  def index
    @merchant = Merchant.find(params[:merchant_id])
    @items = @merchant.items
  end
end
