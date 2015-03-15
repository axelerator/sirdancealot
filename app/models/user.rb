class User < ActiveRecord::Base
  authenticates_with_sorcery! do |config|
    config.authentications_class = Authentication
  end

  has_many :authentications, :dependent => :destroy
  accepts_nested_attributes_for :authentications

  has_many :relationships, inverse_of: :user

  def ownerships
    relationships.ownerships
  end

  def owned_schools
    ownerships
      .joins(:institution)
      .where('institutions.type = ?', School.name)
      .map(&:owns)
  end

end

