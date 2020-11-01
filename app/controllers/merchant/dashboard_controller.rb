class Merchant::DashboardController < ApplicationController
  before_action :current_merchant?

  def show
    @merchant = current_user.merchant
  end
end
