class Message < ActiveRecord::Base
  has_many :relationships, dependent: :destroy
  validates :body, presence: true

  def author
    User
      .joins(:relationships)
      .where(
        relationships: {
          type: Relationships::OwnsMessage.name,
          message_id: self.id
        }
      ).first
  end
end

