class Course < EventGroup

  def add_host!(institution)
    Relationships::CourseGivenBy.create!(event_group: self, host: institution)
    institution.owners.each do |owner|
      self.add_owner!(owner)
    end
  end

  def add_participants(participant)
    participants = Array.wrap(participant)
    participants.each do |p|
      Relationships::Participant.create!(user: p, event_group: self)
    end
  end

  def school
    Relationships::CourseGivenBy.where(event_group_id: self.id).first.try(:host)
  end

end

