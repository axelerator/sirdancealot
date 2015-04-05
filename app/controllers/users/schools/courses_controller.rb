class Users::Schools::CoursesController < ApplicationController
  before_filter :require_login
  before_action :load_school
  before_action :load_course, only: [:show, :edit, :update]

  def index
    @courses = @school.courses
  end

  def show
    cal_start = Time.zone.now.beginning_of_month
    cal_end   = Time.zone.now.end_of_month
    events = @course.events.between(cal_start, cal_end)
    item_hashes = events.map do |event|
      {
        starts_at: event.starts_at,
        ends_at: event.ends_at,
        options: {title: event.event_group.name, event: event}
      }
    end
    @calendar = Carendar::Calendar.new(cal_start, cal_end, item_hashes)
  end

  def new
    @course = Course.new(starts_at: Time.now)
    @course.start_date = Date.today
    @course.schedule_rule = :none
  end

  def create
    @course = Course.new(course_params)
    @course.ends_at = DateTime.now.end_of_year
    @course.generate_schedule
    @course.transaction do
      if @course.save
        @course.add_owner!(current_user)
        @course.add_host!(@school)
        redirect_to user_school_course_path(@school, @course)
      else
        render :new
      end
    end
  end

  def edit
  end

  def update
    if @course.update(course_params)
      redirect_to user_school_course_path(@course)
    else
      render :edit
    end
  end

  private

  def course_params
    p = params
        .require(:course)
        .permit(:name, :dances, :start_time, :duration, :start_date,
                :schedule_rule_weekly_interval,
                :schedule_rule_monthly_mode,
                :schedule_rule,
                { schedule_rule_monthly: [] },
                { schedule_rule_weekly: []}
               )
    p[:starts_at] = DateTime.strptime("#{p[:start_date]}##{p[:start_time]}", "%d.%m.%y#%k:%M")
    p
  end

  def load_course
    @course = @school.courses.find { |course| course.id == params[:id] }
  end

  def schools
    current_user.owned_schools
  end

  def load_school
    @school = schools.find { |school| school.id == params[:school_id] }
  end

end
