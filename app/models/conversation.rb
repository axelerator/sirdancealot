class Conversation < ActiveRecord::Base
  has_many :messages
  has_many :relationships, dependent: :destroy

  scope :direct_conversations, -> do
    Conversation
      .joins(:relationships)
      .where(relationships: {type: Relationships::TalksIn.name})
      .group('conversations.id')
      .having('count(conversations.id) = 2')
  end

  def add_talkers!(talker)
    talkers = Array.wrap(talker)
    talkers.each do |t|
      Relationships::TalksIn.create!(user: t, conversation: self)
    end
  end

  def members
    @members ||= Relationships::TalksIn
      .where(conversation: self)
      .includes(:user)
      .map(&:user)
  end

  def display_name
    members.map(&:display_name).join(', ')
  end

end


