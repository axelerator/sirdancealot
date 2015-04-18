class Message < ActiveRecord::Base
  belongs_to :group
  belongs_to :user
  has_many :relationships, dependent: :destroy
  validates :body, presence: true

  def author
    user
  end
end

