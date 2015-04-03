class Relationships::OwnsInstitution < Relationship
  validates :user, presence: true
  validates :institution, presence: true

  def owns
    institution
  end
end

