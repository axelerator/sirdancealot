class Institution < ActiveRecord::Base
  validates :name, presence: true

  def add_owner!(user)
    Relationships::OwnsInstitution.create!(user: user, institution:self)
  end
end
