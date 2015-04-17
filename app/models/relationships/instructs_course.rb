class Relationships::InstructsCourse < Relationship
  validates :group, presence: true
  validates :user, presence: true
end

