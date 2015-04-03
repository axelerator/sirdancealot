require 'test_helper'

class EventTest < ActiveSupport::TestCase
   test "event factory" do
     assert create(:facility)
     assert create(:dance)
     assert create(:course)
     assert create(:school)
     assert create(:party_row)
     assert create(:lesson)
     assert create(:party)
   end

   test "add_host!" do
     lesson = create(:lesson)
     school = create(:school)

     lesson.add_host!(school)
     assert school.lessons.include?(lesson)
   end
end
