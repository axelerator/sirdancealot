require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "ownerships" do
    school = create(:school)
    user = create(:user)

    Relationships::OwnsInstitution.create(user: user, institution: school)

    assert user.ownerships.map(&:owns).include?(school), "The user should own that school now"
  end
end
