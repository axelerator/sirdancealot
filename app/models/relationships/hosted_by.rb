class Relationships::HostedBy < Relationship
  belongs_to :host, class_name: 'Institution', foreign_key: 'hosted_by_institution_id'

  validates :group, presence: true
  validates :host, presence: true

  def event
    group
  end
end


