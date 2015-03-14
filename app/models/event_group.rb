class EventGroup < ActiveRecord::Base
  has_many :events, dependent: :destroy
  has_and_belongs_to_many :dances
end


