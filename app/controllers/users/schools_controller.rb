class Users::SchoolsController < ApplicationController
  before_filter :require_login
  before_action :load_school, only: [:show, :edit, :update]

  def index
    @schools = schools
  end

  def show
  end

  def new
    @school = School.new
  end

  def create
    School.transaction do
      @school = School.new(school_params)
      if @school.save
        @school.add_owner!(current_user)
        redirect_to user_school_path(@school)
      else
        render :new
      end
    end
  end

  def edit
  end

  def update
    if @school.update(school_params)
      redirect_to user_school_path(@school)
    else
      render :edit
    end
  end

  private

  def school_params
    params.require(:school).permit(:name)
  end

  def schools
    current_user.owned_schools
  end

  def load_school
    @school = schools.find { |school| school.id == params[:id] }
  end

end
