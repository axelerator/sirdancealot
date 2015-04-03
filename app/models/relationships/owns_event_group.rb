class Relationships::OwnsEventGroup < Relationship
  validates :user, presence: true
  validates :event_group, presence: true

  def owns
    event_group
  end
end

