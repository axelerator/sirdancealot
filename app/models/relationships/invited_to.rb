class Relationships::InvitedTo < Relationship
  validates :group, presence: true
end


