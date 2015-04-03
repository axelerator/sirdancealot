class Course < EventGroup

  def add_host!(institution)
    Relationships::CourseGivenBy.create!(event_group: self, host: institution)
  end

  def school
    Relationships::CourseGivenBy.where(event_group_id: self.id).first.try(:host)
  end

end

