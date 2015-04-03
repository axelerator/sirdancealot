class School < Institution
  def courses
    Relationships::CourseGivenBy
      .where(host: self)
      .map(&:event_group)
  end

  def lessons
    Relationships::HostedBy
      .joins(:event)
      .where(host: self)
      .where('events.type = ?', Lesson.name)
      .map(&:event)
  end
end
