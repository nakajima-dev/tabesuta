class UsersController < ApplicationController
  before_action :require_user_logged_in, except: [:new, :create]
  
  before_action :user_exists?, except: [:index, :new, :create, :followings, :followers]
  before_action :set_user, except: [:index, :new, :create, :followings, :followers]
  
  before_action :user_himself?, except: [:index, :show, :new, :create, :followings, :followers]
  
  def index
    @users = User.order(id: :desc).page(params[:page]).per(5)
  end

  def show
    counts(@user)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:success] = 'ユーザを登録しました。'
      redirect_to @user
    else
      flash.now[:danger] = 'ユーザの登録に失敗しました。'
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:success] = "ユーザを更新しました。"
      redirect_to @user
    else
      flash.now[:danger] = "ユーザは更新されませんでした。"
      render :edit
    end
  end

  def destroy
    @user.destroy
    flash[:success] = "正常に退会されました。"
    redirect_to root_url
  end
  
  def followings
    @user = User.find(params[:id])
    @followings = @user.followings.page(params[:page])
    counts(@user)
  end
  
  def followers
    @user = User.find(params[:id])
    @followers = @user.followers.page(params[:page])
    counts(@user)
  end
  
  
  private

  def user_params
    params.require(:user).permit(:name, :email, :birth_date, :password, :password_confirmation)
  end
  
  def set_user
    @user = User.find(params[:id])
  end
  
  def user_himself?
    unless current_user == User.find(params[:id])
      flash[:danger] = "他ユーザの編集はできません。"
      redirect_to user_path(current_user)
    end
  end
  
  def user_exists?
    unless User.exists?(params[:id])
      flash[:danger] = "存在しないユーザです。"
      redirect_to user_path(current_user)
    end
  end
  
end