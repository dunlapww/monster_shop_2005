class OrdersController <ApplicationController

  def new
    if session[:user_id].nil?
      flash[:error] = "You must #{view_context.link_to "log in", '/login'} or #{view_context.link_to "register" , '/register'}"
      redirect_to '/login'
    end
  end

  def show
    @order = Order.find(params[:id])
  end

  def create
    order = Order.create(order_params)
    if order.save
      cart.items.each do |item,quantity|
        order.item_orders.create({
          item: item,
          quantity: quantity,
          price: item.price
          })
      end
      session.delete(:cart)
      flash[:success] = "Your order has been created!"
      redirect_to "/profile/orders/"
    else
      flash[:notice] = "Please complete address form to create an order."
      render :new
    end
  end


  private

  def order_params
    params.permit(:name, :address, :city, :state, :zip, :user_id)
  end
end
