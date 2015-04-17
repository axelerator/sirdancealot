# base class for every entity that can define a group of people
class Group < ActiveRecord::Base
  has_many :messages
  has_many :relationships, dependent: :destroy
  has_and_belongs_to_many :dances
end

