class VisitorsController < ApplicationController
  def self.r=(rr)
    @r = rr
  end

  def self.r
    @r
  end


  def index
    VisitorsController.r = Random.new(125)
    week = DateTime.now.beginning_of_week
    ungrouped_items = 40.times.map do |i|
      day = VisitorsController.r.rand(12).to_i
      s_time = VisitorsController.r.rand(265).to_i
      e_time = VisitorsController.r.rand([268 - s_time - 1, 60].min + 15).to_i + 1 + s_time
      opts = {
        title: Faker::Lorem.words(2).join(" ")
      }
      if s_time.even?
        opts[:class] = 'important'
      end
      {starts_at: week + day.days + (5* s_time).minutes,
       ends_at: week + day.days + (5*e_time).minutes,
       options: opts }
    end
    @calendar = Carendar::Calendar.new(DateTime.now.beginning_of_month, DateTime.now.end_of_month + 1.week, ungrouped_items)
  end
end
