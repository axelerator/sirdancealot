class Relationships::TalksIn < Relationship
  validates :user, presence: true
  validates :conversation, presence: true
end

