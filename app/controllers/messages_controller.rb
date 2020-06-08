class MessagesController < ApplicationController
  before_action :require_user_logged_in
  def create
    if Entry.where(:user_id => current_user.id, :room_id => params[:message][:room_id]).present?
      @message = Message.create(params.require(:message).permit(:user_id, :content, :room_id).merge(:user_id => current_user.id))
      redirect_to "/rooms/#{@message.room_id}"
    else
      
      redirect_back(fallback_location: user_path(current_user))
    end
    # binding.pry
  end
end
