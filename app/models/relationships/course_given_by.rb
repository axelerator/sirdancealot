class Relationships::CourseGivenBy < Relationship
  belongs_to :host, class_name: 'Institution', foreign_key: 'hosted_by_institution_id'

  validates :group, presence: true # event_group
  validates :other_group, presence: true

  def event_group
    group
  end
end



