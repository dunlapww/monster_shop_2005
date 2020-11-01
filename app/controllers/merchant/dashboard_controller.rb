class Merchant::DashboardController < ApplicationController
  before_action :current_merchant?

  def show
    require 'pry'; binding.pry
  end
end
