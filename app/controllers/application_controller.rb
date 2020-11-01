class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :cart, :current_user

  def cart
    @cart ||= Cart.new(session[:cart] ||= Hash.new(0))
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def current_admin?
    current_user && current_user.admin?
  end

  def no_admin
    render file: '/public/404' if current_admin?
  end

  def current_user?
    render file: '/public/404' unless current_user
  end

  def current_merchant?
    render file: '/public/404' unless (current_user && current_user.merchant_employee?)
  end
end
