class Users::SchoolsController < ApplicationController
  before_filter :require_login
  before_action :load_school, only: [:show, :edit, :update]

  def index
    @schools = schools
  end

  def show
    cal_start = Time.now.beginning_of_week
    cal_end   = Time.now.end_of_week
    events = @school.hosted_events(cal_start, cal_end)
    debugger
    item_hashes = events.map do |event|
      {
        starts_at: event.starts_at,
        ends_at: event.ends_at,
        options: {title: event.event_group.name}
      }
    end
    @calendar = Carendar::Calendar.new(cal_start, cal_end, item_hashes)

  end

  def new
    @school = School.new
  end

  def create
    School.transaction do
      @school = current_user.create_school(school_params)
      if @school.errors.any?
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
