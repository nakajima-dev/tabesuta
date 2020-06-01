# 以下のrequireは、railsの自動require機能により不要になる(!)
require 'net/http'
require 'uri'
require 'json'
#定数はオブジェクト指向内で定義できない！？
API_BASE_URL = 'http://webservice.recruit.co.jp/hotpepper/gourmet/v1/'
API_KEY = 'dd8e8f55a9899dae'


class SearchesController < ApplicationController
  
  
  before_action :require_user_logged_in
  
  
  def show
    get_api
  end
  
  
  
  
  
  private
  # Strong Parameter
  def search_params
    params.permit(:keyword,:page)
  end
  
  
  def get_api
    if params.has_key?(:keyword)
      uri_para = {
      'keyword' => URI.encode(params[:keyword]),
      'service_area' => 'SA11',
      'start' => 10 * (params[:page].to_i - 1) + 1,
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
            @results_available = @results["results_available"]
            @results_start = @results["results_start"]
            @searches = Kaminari.paginate_array(@results["shop"], total_count: @results_available).page((@results_start -1)/10 + 1).per(10)
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
      
    else
      redirect_to root_path
    end
  end
  
  
  
end
