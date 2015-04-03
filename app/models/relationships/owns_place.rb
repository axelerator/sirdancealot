class Relationships::OwnsPlace < Relationship
  validates :user, presence: true
  validates :place, presence: true

  def owns
    place
  end
end

