class Relationships::OwnsInstitution < Relationship
  validates :institution, presence: true

  def owns
    institution
  end
end

