class Relationships::OwnsEvent < Relationship
  validates :user, presence: true
  validates :event, presence: true

  def owns
    event
  end
end

