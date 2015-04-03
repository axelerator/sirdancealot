require 'test_helper'

class EventGroupTest < ActiveSupport::TestCase

   test "add_host!" do
     course = create(:course)
     school = create(:school)

     course.add_host!(school)
     assert school.courses.include?(course)
   end

   test "recurrences" do
     starts_at = Date.parse('01.05.2016')
     ends_at = starts_at.end_of_month
     course = build(:course,
                      starts_at: starts_at,
                      ends_at: ends_at,
                      schedule_rule_weekly_interval: 1,
                      schedule_rule_weekly: [1],
                      schedule_rule: :weekly)
     course.generate_schedule
     course.save!
     assert_equal 5, course.occurrences.length
   end

end
