class Institution < Group
  validates :name, presence: true

  def hosted_events_rel(start_day, end_day)
    starts_at = start_day.beginning_of_day
    ends_at = end_day.end_of_day
    Group
      .joins(:relationships)
      .where(relationships: {
        type: Relationships::HostedBy.name,
        other_group: self })
      .where('starts_at > ?', starts_at)
      .where('ends_at < ?', ends_at)
  end

  def hosted_events(start_day = Date.today, end_day = (Time.now + 1.year).to_date)
    hosted_events_rel(start_day, end_day)
  end

  def owners
    Relationships::OwnsInstitution
      .joins(:user)
      .where(group_id: self.id)
      .map(&:user)
  end

  def add_owner!(user)
    Relationships::OwnsInstitution.create!(user: user, group: self)
    # TODO: add new owner as owner of hosted events
  end
end
