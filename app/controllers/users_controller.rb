# 以下のrequireは、railsの自動require機能により不要になる(!)
require 'net/http'
require 'uri'
require 'json'
#定数はオブジェクト指向内で定義できない！？
API_BASE_URL = 'http://webservice.recruit.co.jp/hotpepper/gourmet/v1/'
API_KEY = 'dd8e8f55a9899dae'



class UsersController < ApplicationController
  before_action :require_user_logged_in, except: [:new, :create]
  
  before_action :user_exists?, except: [:index, :new, :create]
  before_action :set_user, except: [:index, :new, :create]
  
  before_action :user_himself?, except: [:index, :show, :new, :create, :followings, :followers, :likes]
  
  before_action :fav_exists?, only: [:likes]
  
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
    @followings = @user.followings.page(params[:page])
    counts(@user)
  end
  
  def followers
    @followers = @user.followers.page(params[:page])
    counts(@user)
  end
  
  def likes
    @likes = @user.shops.order(updated_at: :desc)
    params[:page] ||= "1"
    start_id = 10 * (params[:page].to_i - 1)
    if @likes.count <= (start_id + 9)
      end_id = @likes.count - 1
    else
      end_id = start_id + 9
    end
    id_str = ""
    (start_id..end_id).each do |ind|
      id_str += (@likes[ind][:number] + ",")
    end
    id_str.chop!
    
    get_fav_api(id_str)
    
    
    @results_available = @likes.count
    @results_start = start_id + 1
    @searches = Kaminari.paginate_array(@shops, total_count: @results_available).page((@results_start -1)/10 + 1).per(10)
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
  
  def fav_exists?
    unless User.find(params[:id]).shops.exists?
      flash[:danger] = "まだお気に入りがありません。"
      redirect_to user_path(User.find(params[:id]))
    end
  end
  
  
  def get_fav_api(id_str)
    
    uri_para = {
    'id' => URI.encode(id_str),
    'format' => 'json'
    }
    uri = URI.parse(API_BASE_URL + '?key=' + API_KEY + '&' + uri_para.map{|k,v| "#{k}=#{v}"}.join('&'))
    # リクエストパラメタを、インスタンス変数に格納
    @query = uri.query
    
    # 新しくHTTPセッションを開始し、結果をresponseへ格納
    response = Net::HTTP.start(uri.host, uri.port) do |http|
      # 接続時に待つ最大秒数を設定
      http.open_timeout = 5
      # 読み込み一回でブロックして良い最大秒数を設定
      http.read_timeout = 10
      # ここでWebAPIを叩いている
      # Net::HTTPResponseのインスタンスが返ってくる
      http.get(uri.request_uri)
    end
    
    # 例外処理の開始
    begin
      # responseの値に応じて処理を分ける
      case response
      # 成功した場合
      when Net::HTTPSuccess
        # responseのbody要素をJSON形式で解釈し、hashに変換
        @results = JSON.parse(response.body)["results"]
        if @results.has_key?("error")
          # binding.pry
          @error = @results["error"][0]
        
        else
          @shops = @results["shop"]
        end
      # 別のURLに飛ばされた場合
      when Net::HTTPRedirection
        @message = "Redirection: code=#{response.code} message=#{response.message}"
      # その他エラー
      else
        @message = "HTTP ERROR: code=#{response.code} message=#{response.message}"
      end
    # エラー時処理
    rescue IOError => e
      @message = "e.message"
    rescue TimeoutError => e
      @message = "e.message"
    rescue JSON::ParserError => e
      @message = "e.message"
    rescue => e
      @message = "e.message"
    end
  end
    
end