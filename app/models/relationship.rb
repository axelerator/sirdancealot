class Relationship < ActiveRecord::Base
  belongs_to :user, inverse_of: :relationships
  belongs_to :group
  belongs_to :other_group, class_name: 'Group' # for inter-group relationships
  belongs_to :message


  scope :ownerships, -> { where(type: [Relationships::OwnsEvent, Relationships::OwnsInstitution, Relationships::OwnsEventGroup,Relationships::OwnsPlace].map(&:name))}
  scope :course_given_by, -> { where(type: Relationships::CourseGivenBy.name) }
end

