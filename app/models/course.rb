class Course < EventGroup

  def add_host!(institution)
    Relationships::CourseGivenBy.create!(event_group: self, host: institution)
    institution.owners.each do |owner|
      self.add_owner!(owner)
    end
  end

  def add_participants!(participant)
    super
    Array.wrap(participant).each do |p|
      Relationships::MemberAt.create!(user: p, institution: school)
    end
  end

  def school
    Relationships::CourseGivenBy.where(event_group_id: self.id).first.try(:host)
  end

end

