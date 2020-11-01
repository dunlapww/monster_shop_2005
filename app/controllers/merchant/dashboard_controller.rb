class Merchant::DashboardController < ApplicationController
  before_action :current_merchant?

  def show
    @user = current_user
  end
end
