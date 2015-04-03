class Relationships::CourseGivenBy < Relationship
  belongs_to :host, class_name: 'Institution', foreign_key: 'hosted_by_institution_id'

  validates :event_group, presence: true
  validates :host, presence: true
end



