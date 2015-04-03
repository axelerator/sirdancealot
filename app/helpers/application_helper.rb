module ApplicationHelper
  def owned_item_link(entity)
    case entity
    when School
      link_to entity.name, user_school_path(entity)
    when Course
      link_to entity.name, user_school_course_path(entity.school, entity)
    else
      "#{entity.class}:#{entity.id}"
    end
  end
end
