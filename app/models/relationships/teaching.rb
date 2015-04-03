class Relationships::Teaching < Relationship
  validates :institution, presence: true
end

