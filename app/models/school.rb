class School < Institution
  def add_teachers!(teacher)
    teachers = Array.wrap(teacher)
    teachers.each do |t|
      Relationships::TeachesAt.create!(user: t, institution: self)
    end
  end

  def courses
    hosted_event_groups_rel
      .where(type: Relationships::CourseGivenBy.name)
      .map(&:event_group)
  end

  def lessons(start_day = Date.today, end_day = (Time.now + 1.year).to_date)
    hosted_events_rel(start_day, end_day)
      .where('events.type = ?', Lesson.name)
      .map(&:event)
  end

  def teachers
    Relationships::TeachesAt
      .where(institution: self)
  end

  def members
    Relationships::MemberAt
      .where(institution: self)
      .includes(:user)
      .map(&:user)
  end

  def create_place(params)
    place = Place.create!(params)
    self.transaction do
      if place.save
        place.add_owners!(owners)
      end
    end
    place
  end

  def create_course(params, place)
    course = Course.new(params)
    course.end_day = DateTime.now.end_of_year
    course.transaction do
      course.generate_schedule
      if course.save
        course.add_host!(self)
        course.occurrences.each do |occurrence|
          lesson = Lesson.create!(event_group: course,
                        starts_at: occurrence.start_time,
                        ends_at: occurrence.start_time + course.duration.minutes,
                        place: place)
          lesson.add_host!(self)
        end
      end
    end
    course
  end
end
