require 'test_helper'

class EventTest < ActiveSupport::TestCase
   test "event factory" do
     assert create(:facility)
     assert create(:dance)
     assert create(:course)
     assert create(:party_row)
     assert create(:lesson)
     assert create(:party)
   end
end
