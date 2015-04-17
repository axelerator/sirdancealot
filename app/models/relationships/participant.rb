class Relationships::Participant < Relationship
  validates :group, presence: true

  def event_group
    group
  end
end


