class UsersController < ApplicationController
  before_action :require_login
  def show
    @user = current_user

    @owned_items = @user
                     .ownerships
                     .map(&:owns)
                     .group_by(&:class)
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update_attributes(user_params)
      redirect_to action: :show
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :profile_image)
  end

end

