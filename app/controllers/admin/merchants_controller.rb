class Admin::MerchantsController < ApplicationController
  def index
    @merchants = Merchant.all
  end

  def show
    @merchant = Merchant.find(params[:id])
  end

  def update
    merchant = Merchant.find(params[:id])
    merchant.toggle!(:active?)
    flash[:success] = merchant.active? ? "Merchant #{merchant.name} Enabled" : "Merchant #{merchant.name} Disabled"
    redirect_to '/admin/merchants'
  end
end
