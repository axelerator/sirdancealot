class Relationships::OwnsPlace < Relationship
  belongs_to :place

  validates :user, presence: true
  validates :place, presence: true

  def owns
    place
  end
end

