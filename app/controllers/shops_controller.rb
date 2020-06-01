class ShopsController < ApplicationController
  before_action :require_user_logged_in
  
  def create
    unless current_user.shops.exists?(number: params[:number])
      current_user.shops.build(number: params[:number]).save
      current_user.shops.reload
      @num = params[:number]
    end
  end

  def destroy
    if current_user.shops.exists?(number: params[:number])
      current_user.shops.find_by(number: params[:number]).destroy
      current_user.shops.reload
      @num = params[:number]
    end
  end
  
  private
  
  
  
end
