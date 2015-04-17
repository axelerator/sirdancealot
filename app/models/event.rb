class Event < Group
  belongs_to :place

  belongs_to :event_group, class_name: 'EventGroup', foreign_key: 'group_id'
  validates :event_group, :place, :starts_at, :ends_at, presence: true
  scope :between, -> (from, to) { where('starts_at > ? and ends_at < ?', from.beginning_of_day, to.beginning_of_day)}
  scope :upcoming, -> { where('starts_at > ?', Time.zone.now)}
  scope :by_start, -> { order(:starts_at) }
  scope :for_next_days, -> (days) { where('starts_at > ? and ends_at < ?', Time.zone.local_to_utc(Time.now), Time.zone.local_to_utc(Time.now) + days.days)}

  def add_host!(institution)
    Relationships::HostedBy.create!(group: self, host: institution)
    add_owners!(institution.owners)
  end

  def add_owners!(owner)
    owners = Array.wrap(owner)
    owners.each do |o|
      Relationships::OwnsEvent.create!(group: self, user: o)
    end
  end

  def invite!(invitee)
    invitees = Array.wrap(invitee)
    invitees.each do |i|
      Relationships::InvitedTo.create!(event: self, user: i)
    end
  end

  def attendees
    User.joins(:relationships)
        .where(relationships: {
          type: Relationships::Attended.name,
          group_id: self.id
        })
  end

  def name
    event_group.name
  end
end

