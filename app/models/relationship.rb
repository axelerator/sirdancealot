class Relationship < ActiveRecord::Base
  belongs_to :user, inverse_of: :relationships
  belongs_to :institution
  belongs_to :event_group
  belongs_to :event

  validates :user, presence: true

  scope :ownerships, -> { where(type: [OwnsEvent, Relationships::OwnsInstitution, OwnsEventGroup].map(&:name))}
end

class OwnsEventGroup < Relationship
  validates :event_group, presence: true

  def owns
    event_group
  end
end

class OwnsEvent < Relationship
  validates :event, presence: true

  def owns
    event
  end
end

class RVSPEvent < Relationship
  validates :event, presence: true
end

class RVSPEventYes < RVSPEvent
  validates :event, presence: true
end

class RVSPEventNo < RVSPEvent
  validates :event, presence: true
end

class RVSPEventMaybe < RVSPEvent
  validates :event, presence: true
end

class Teaching < Relationship
  validates :institution, presence: true
end
