class Relationships::InvitedTo < Relationship
  validates :event, presence: true
end


