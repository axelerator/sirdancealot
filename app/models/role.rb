class Role < ActiveRecord::Base
  self.abstract_class = true
  belongs_to :user, inverse_of: :roles

  validates :user, presence: true
end
