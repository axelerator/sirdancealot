class EventGroup < Group
  include IceCube

  has_many :events, dependent: :destroy, foreign_key: 'group_id'
  validates :start_day, :start_time, presence: true

  RECURRING_SCHEDULE_RULES = [:weekly, :monthly]
  SCHEDULE_RULES = [:none] + RECURRING_SCHEDULE_RULES
  serialize :schedule, Hash
  attr_accessor :schedule_rule, :schedule_rule_weekly_interval, :schedule_rule_weekly,
    :schedule_rule_monthly, :schedule_rule_monthly_mode, :recurrence_type,
    :duration

  def add_owner!(user)
    Relationships::OwnsEventGroup.create!(group: self, user: user)
    # TODO: add owner to all dd
  end

  def add_host!(institution)
    Relationships::CourseGivenBy.create!(group: self, host: institution)
  end

  def add_participants!(participant)
    participants = Array.wrap(participant)
    events = self.events.upcoming
    participants.each do |p|
      Relationships::Participant.create!(user: p, group: self)
    end

    events.each do |event|
      event.invite!(participants)
    end
  end

  def conversation
    Conversation.where(group_id: self.id)
  end

  def send_message!(body, from_user)

  end

  def participants
    User
      .joins(:relationships)
      .where(relationships: {
        type: Relationships::Participant.name,
        group_id: self.id
      })
  end

  def schedule=(new_schedule)
    write_attribute(:schedule, new_schedule.to_hash)
    explode_schedule
  end

  def has_schedule?
    read_attribute(:schedule).present?
  end

  def generate_schedule
    return if schedule_rule.nil?

    new_schedule = Schedule.new(start_day + start_time.minutes)
    case self.schedule_rule.to_sym
    when :none
      rule = nil
      new_schedule.add_recurrence_time start_time
    when :weekly
      self.schedule_rule_weekly_interval = 1 if self.schedule_rule_weekly_interval.blank?
      rule = Rule.weekly(self.schedule_rule_weekly_interval.to_i, :monday)
      rule.day(*(schedule_rule_weekly.map(&:to_i)))
    when :monthly
      rule = Rule.monthly.month_of_year(*(schedule_rule_monthly.map(&:to_i)))
      case self.schedule_rule_monthly_mode.to_sym
      when :day_of_month
        # noop
      when :day_of_month_reverse
        rule.day_of_month(schedule_day.day - schedule_day.end_of_month.day - 1)
      when :weekday
        rule.day_of_week({schedule_day.wday => [(schedule_day.day / 7).to_i + 1] })
      when :weekday_reverse
        weekday = ((schedule_day.day - schedule_day.end_of_month.day - 1) / 7).to_i
        rule.day_of_week({schedule_day.wday => [weekday] })
      end
    else
      raise "Encountered unknown rule while generating schedule: #{self.schedule_rule}"
    end
    new_schedule.add_recurrence_rule(rule) unless rule.nil?
    self.schedule = new_schedule
  end

  def occurrences
    schedule.occurrences_between(start_day, end_day)
  end

  def schedule
    if self.has_schedule?
      Schedule.from_hash(read_attribute(:schedule))
    else
      Schedule.new
    end
  end

  def explode_schedule
    if schedule.nil? || schedule.recurrence_rules.empty?
      self.schedule_rule = :none
      return
    end

    rule = schedule.recurrence_rules.first # We only support one single recurrence rule

    case rule
    when IceCube::WeeklyRule
      self.schedule_rule = :weekly
      self.schedule_rule_weekly = rule.to_hash[:validations][:day]
      self.schedule_rule_weekly_interval = rule.to_hash[:interval]
    when IceCube::MonthlyRule
      self.schedule_rule = :monthly
      self.schedule_rule_monthly = rule.to_hash[:validations][:month_of_year]
      self.schedule_rule_monthly_mode = :day_of_month
      if rule.to_hash[:validations][:day_of_month].present?
        self.schedule_rule_monthly_mode = :day_of_month_reverse
      else
        if rule.to_hash[:validations][:day_of_week].present?
          wday = rule.to_hash[:validations][:day_of_week][starts_day.wday]
          if  wday == [(starts_day.day / 7).to_i + 1]
            self.schedule_rule_monthly_mode = :weekday
          else
            self.schedule_rule_monthly_mode = :weekday_reverse
          end
        end
      end
    else
      raise "Unable to explode schedule: #{schedule.to_hash}"
      return
    end
  end

end


