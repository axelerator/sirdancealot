class UsersController < ApplicationController
  before_action :require_login
  def show
    @user = current_user

    @owned_items = @user
                     .ownerships
                     .map(&:owns)
                     .group_by(&:class)
  end
end

