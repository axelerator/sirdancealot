class Relationships::OwnsMessage < Relationship
  validates :user, presence: true
  validates :message, presence: true

  def owns
    message
  end
end

