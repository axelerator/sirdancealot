class School < Institution
  def courses
    hosted_event_groups_rel
      .where(type: Course.name)
      .map(&:event_group)
  end

  def lessons(start_day = Date.today, end_day = (Time.now + 1.year).to_date)
    hosted_events_rel(start_day, end_day)
      .where('events.type = ?', Lesson.name)
      .map(&:event)
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
    course.ends_at = DateTime.now.end_of_year
    course.transaction do
      course.generate_schedule
      if course.save
        course.add_host!(self)
        course.occurrences.each do |occurrence|
          lesson = Lesson.create!(event_group: course,
                        starts_at: occurrence.start_time,
                        ends_at: occurrence.end_time,
                        place: place)
          lesson.add_host!(self)
        end
      end
    end
    course
  end
end
