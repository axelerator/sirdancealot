class Course < EventGroup

  def add_host!(institution)
    Relationships::CourseGivenBy.create!(group: self, host: institution)
    institution.owners.each do |owner|
      self.add_owner!(owner)
    end
  end

  def add_teachers!(teacher)
    teachers = Array.wrap(teacher)
    self.transaction do
      teachers.each do |t|
        Relationships::InstructsCourse.create!(event_group: self, user: t)
      end
      schools.each do |school|
        school.add_teachers!(teachers)
      end
    end
  end

  def teachers
    User
      .joins(:relationships)
      .where(relationships: {
              type: Relationships::InstructsCourse.name,
              event_group: self
      })
  end

  def add_participants!(participant)
    super
    Array.wrap(participant).each do |p|
      Relationships::MemberAt.create!(user: p, institution: school)
    end
  end

  def schools
    School.joins(:relationships)
      .where(relationships: {
        type: Relationships::CourseGivenBy.name,
        event_group_id: self.id
      })
  end

  def school
    schools.first
  end

end

