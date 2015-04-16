class Relationships::ReceivedMessage < Relationship
  validates :user, presence: true
  validates :message, presence: true
end

