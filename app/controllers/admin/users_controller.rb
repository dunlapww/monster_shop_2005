class Admin::UsersController < ApplicationController
  before_action :require_admin

  def index
    @users = User.all
  end
end
