class Relationships::Ownership < Relationship
  validates :user, presence: true
  validates :group, presence: true

  def owns
    group
  end
end

