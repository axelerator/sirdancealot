class Relationships::TeachesAt < Relationship
  validates :institution, presence: true
end

