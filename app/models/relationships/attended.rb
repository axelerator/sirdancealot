class Relationships::Attended < Relationship
  validates :event, presence: true
end


