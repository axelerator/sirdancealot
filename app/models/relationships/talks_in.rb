class Relationships::TalksIn < Relationship
  validates :user, presence: true
  validates :group, presence: true
end

