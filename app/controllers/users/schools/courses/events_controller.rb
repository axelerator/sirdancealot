class Users::Schools::Courses::EventsController < ApplicationController
  before_filter :require_login
  before_action :load_school
  before_action :load_course
  before_action :load_event, only: [:show, :edit, :update, :toggle_attendance]

  def show
    @participants = @event.event_group.participants
    @attendees = @event.attendees
    @participants -= @attendees
  end

  def toggle_attendance
    user = User.find(params[:user_id])
    attendance = Relationships::Attended.find_by(group: @event, user: user)
    if attendance
      attendance.destroy
    else
      Relationships::Attended.create!(group: @event, user: user)
    end
    redirect_to action: :show
  end

  private

  def load_course
    @course = @school.courses.find { |course| course.id == params[:course_id] }
  end

  def schools
    current_user.owned_schools
  end

  def load_school
    @school = schools.find { |school| school.id == params[:school_id] }
  end

  def load_event
    @event = @course.events.find(params[:id])
  end
end

