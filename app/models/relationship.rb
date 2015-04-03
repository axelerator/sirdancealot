class Relationship < ActiveRecord::Base
  belongs_to :user, inverse_of: :relationships
  belongs_to :institution
  belongs_to :event_group
  belongs_to :event


  scope :ownerships, -> { where(type: [Relationships::OwnsEvent, Relationships::OwnsInstitution, Relationships::OwnsEventGroup,Relationships::OwnsPlace].map(&:name))}
  scope :course_given_by, -> { where(type: Relationships::CourseGivenBy.name) }
end

