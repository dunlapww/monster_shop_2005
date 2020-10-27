class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :cart, :current_user

  def cart
    @cart ||= Cart.new(session[:cart] ||= Hash.new(0))
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def not_found
    raise ActionController::RoutingError.new('404 not found')
  end

  def current_admin?
    current_user && current_user.admin?
  end

  def current_user?
    render file: '/public/404' unless current_user
  end
end
