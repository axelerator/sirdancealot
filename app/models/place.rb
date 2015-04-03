class Place < ActiveRecord::Base
  validates :name, presence: true

  def add_owners!(owner)
    owners = Array.wrap(owner)
    owners.each do |owner|
      Relationships::OwnsPlace.create!(place: self, user: owner)
    end
  end
end
