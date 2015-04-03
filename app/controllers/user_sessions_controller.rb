class UserSessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    if @user = login(params[:login][:email], params[:login][:password])
      redirect_back_or_to(:root, notice: 'H18N Login successful')
    else
      flash.now[:alert] = 'H18N Login failed'
      render action: 'new'
    end
  end

  def destroy
    logout
    redirect_to(:users, notice: 'Logged out!')
  end
end
