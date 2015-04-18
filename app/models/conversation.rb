class Conversation < Group

  def self.between_direct(u1, u2)
    u1_ids, u2_ids = [u1, u2].map do |user|
      Conversation
        .joins(:relationships)
        .where(relationships: {
          type: Relationships::TalksIn,
          user: user
        }).pluck(:id)
    end
    Conversation.where(id: u1_ids & u2_ids).first

  end

  def self.create_between!(u1, u2)
    conversation = Conversation.new
    self.transaction do
      conversation.save!
      Relationships::TalksIn.create!(user: u1, group: conversation)
      Relationships::TalksIn.create!(user: u2, group: conversation)
    end
    conversation
  end

  def members
    User.joins(:relationships)
      .where(relationships: {
          type: Relationships::TalksIn,
          group: self
      })
      .distinct
  end

  def display_name
    members.map(&:display_name).join(', ')
  end

end


