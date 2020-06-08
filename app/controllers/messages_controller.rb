class MessagesController < ApplicationController
  before_action :require_user_logged_in
  def create
    # binding.pry
    if Entry.where(:user_id => current_user.id, :room_id => params[:message][:room_id]).present?
      @message = Message.new(params.require(:message).permit(:user_id, :content, :room_id).merge(:user_id => current_user.id))
      
      if @message.save
        # binding.pry
        
        
      else
        # binding.pry
        flash[:danger] = "メッセージが送信できません。１文字以上入力してください"
        # render "/rooms/#{@message.room_id}"
        # render template: 'rooms/show'
      end
      redirect_to "/rooms/#{@message.room_id}"
      
    else
      
      redirect_back(fallback_location: user_path(current_user))
    end
    
  end
end
