class Course < EventGroup

  def add_host!(institution)
    raise "Institution must be persisted #{institution.errors.full_messages}" unless institution.persisted?
    raise "course must be persisted #{self.errors.full_messages}" unless persisted?
    Relationships::CourseGivenBy.create!(group: self, other_group: institution)
    institution.owners.each do |owner|
      self.add_owner!(owner)
    end
  end

  def add_teachers!(teacher)
    teachers = Array.wrap(teacher)
    self.transaction do
      teachers.each do |t|
        Relationships::InstructsCourse.create!(group: self, user: t)
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
              group: self
      })
  end

  def add_participants!(participant)
    super
    Array.wrap(participant).each do |p|
      schools.each do |school|
        Relationships::MemberAt.create!(user: p, group: school)
      end
    end
  end

  def schools
    # must join on other_group here to get host

    School.joins('INNER JOIN "relationships" ON "relationships"."other_group_id" = "groups"."id"')
      .where(relationships: {
        type: Relationships::CourseGivenBy.name,
        group_id: self.id
      })
  end

  def school
    schools.order(:created_at).first
  end

end

