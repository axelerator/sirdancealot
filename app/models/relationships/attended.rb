class Relationships::Attended < Relationship
  validates :group, presence: true
end


