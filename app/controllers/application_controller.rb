class ApplicationController < ActionController::Base
  
  include SessionsHelper
  include UsersHelper
  
  
  private

  def require_user_logged_in
    unless logged_in?
      redirect_to login_url
    end
  end
  
  def counts(user)
    @count_followings = user.followings.count
    @count_followers = user.followers.count
    @count_likes = user.shops.count
  end
end
