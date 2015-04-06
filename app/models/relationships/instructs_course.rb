class Relationships::InstructsCourse < Relationship
  validates :event_group, presence: true
  validates :user, presence: true
end

