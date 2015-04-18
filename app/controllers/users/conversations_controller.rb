class Users::ConversationsController < ApplicationController
  before_action :require_login
  before_action :load_conversations

  def index
    redirect_to user_conversation_path(@conversations.first) if @conversations.any?
  end

  def show
    @conversation = @conversations.find(params[:id])
    @messages = @conversation.messages
  end

  private

  def load_conversations
    @conversations = current_user.conversations
  end

end

