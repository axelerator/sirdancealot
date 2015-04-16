class User < ActiveRecord::Base
  authenticates_with_sorcery! do |config|
    config.authentications_class = Authentication
  end

  has_many :authentications, :dependent => :destroy
  accepts_nested_attributes_for :authentications

  has_many :relationships, inverse_of: :user

  def display_name
    email
  end

  def ownerships
    relationships.ownerships
  end

  def owned_schools
    ownerships
      .joins(:institution)
      .where('institutions.type = ?', School.name)
      .map(&:owns)
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

  def conversations_rel
    Conversation
      .joins(:relationships)
      .where(relationships: {
        user: self,
        type: Relationships::TalksIn.name
      })
  end

  def conversations
     conversations_rel
  end

  def send_message!(body, user)
    my_ids = conversations_rel.distinct('conversations.id')
    his_ids = user.conversations_rel.distinct('conversations.id')
    conversation = Conversation.where(id: my_ids & his_ids).first
    Conversation.transaction do
      if conversation.nil?
        conversation = Conversation.create!
        conversation.add_talkers!([self, user])
      end
      message = conversation.messages.create!(body: body)
      Relationships::OwnsMessage.create!(message: message, user: self)
      message
    end

  end

end

