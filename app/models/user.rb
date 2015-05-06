class User < ActiveRecord::Base
  extend Dragonfly::Model
  dragonfly_accessor :profile_image

  authenticates_with_sorcery! do |config|
    config.authentications_class = Authentication
  end

  has_many :authentications, :dependent => :destroy
  accepts_nested_attributes_for :authentications

  has_many :relationships, inverse_of: :user, :dependent => :destroy

  def has_profile_image?
    !profile_image.nil?
  end

  def profile(size = :thumb)
    dim = {thumb: '100x100#'}
    profile_image.thumb(dim[size.to_sym])
  end

  def display_name
    email
  end

  def events(for_next_days = 8)
    Event
      .joins(:relationships)
      .where(relationships: {
        type: Relationships::InvitedTo,
        user: self })
      .by_start
      .for_next_days(for_next_days)
  end

  def ownerships
    relationships.ownerships
  end

  def owned_schools
    School.joins(:relationships)
      .where(relationships: {
              type: Relationships::OwnsInstitution,
              user: self})
  end

  def owned_courses
    ownerships
      .joins(:event_group)
      .where('event_groups.type = ?', Course.name)
      .map(&:owns)
  end

  def create_school(params)
    school = School.new(params)
    school.add_owner!(self) if school.save
    school
  end

  def conversations
    Conversation
      .select('groups.*, max(messages.created_at) as last_action_at')
      .joins(:messages)
      .joins(:relationships)
      .where(relationships: {
          type: Relationships::TalksIn,
          user: self})
      .group('groups.id')
      .order('last_action_at')
      .having('count(messages.id) > 0')
      .distinct
  end

  def conversations_with(user)
    Conversation.between_direct(self, user)
  end

  def send_message!(body, user)
    conversation = conversations_with(user)
    Conversation.transaction do
      if conversation.nil?
        conversation = Conversation.create_between!(self, user)
      end
      message = conversation.messages.create!(body: body, user: self, group: conversation)
      message
    end

  end

end

