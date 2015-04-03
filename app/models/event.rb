class Event < ActiveRecord::Base
  has_and_belongs_to_many :dances
  belongs_to :place
  belongs_to :event_group

  validates :event_group, :place, :starts_at, :ends_at, presence: true

  def add_host!(institution)
    Relationships::HostedBy.create!(event: self, host: institution)
  end
end

