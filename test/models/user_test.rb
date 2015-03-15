require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "ownerships" do
    Relationship # force relationship.rb to load
    school = create(:school)
    user = create(:user)

    OwnsInstitution.create(user: user, institution: school)

    assert user.ownerships.map(&:owns).include?(school), "The user should own that school now"
  end
end
