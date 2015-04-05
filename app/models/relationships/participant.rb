class Relationships::Participant < Relationship
  validates :event_group, presence: true
end


