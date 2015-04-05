module ApplicationHelper
  def owned_item_link(entity)
    case entity
    when School
      link_to entity.name, user_school_path(entity)
    when Course
      link_to entity.name, user_school_course_path(entity.school, entity)
    when Lesson
      lesson = entity
      course = lesson.course
      school = course.school
      link_to entity.course.name, user_school_course_event_path(school, course, lesson)
    else
      "#{entity.class}:#{entity.id}"
    end
  end
end
