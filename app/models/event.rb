class Event < ActiveRecord::Base
  has_and_belongs_to_many :dances
  belongs_to :place
  belongs_to :event_group

  validates :event_group, :place, :starts_at, :ends_at, presence: true

  def add_host!(institution)
    Relationships::HostedBy.create!(event: self, host: institution)
    add_owners!(institution.owners)
  end

  def add_owners!(owner)
    owners = Array.wrap(owner)
    owners.each do |owner|
      Relationships::OwnsEvent.create!(event: self, user: owner)
    end
  end
end

