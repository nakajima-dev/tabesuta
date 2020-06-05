  def api_list
    @api_list = {'base' => 'http://webservice.recruit.co.jp/hotpepper/gourmet/v1/',
               'large_area' => 'http://webservice.recruit.co.jp/hotpepper/large_area/v1/',
               'middle_area' => 'http://webservice.recruit.co.jp/hotpepper/middle_area/v1/',
               'genre' => 'http://webservice.recruit.co.jp/hotpepper/genre/v1/',
               'budget' => 'http://webservice.recruit.co.jp/hotpepper/budget/v1/'}
  end
  def term_list
    @term_list = {"large_area" => [["都道府県", ""]], 
                   "genre" => [["ジャンル", ""]],
                   "budget" => [["予算", ""]]}
  end
  
  def term_list_name
    @term_list_name = {"large_area" => [],
                       "genre" => [],
                       "budget" => [],
                       "keyword" => []
    }
  end
  
  def api_key
    @api_key = 'dd8e8f55a9899dae'
  end




def get_api
  if params.has_key?(:large_area)
    uri_para = {
    'keyword' => URI.encode(params[:keyword]),
    'large_area' => URI.encode(params[:large_area]),
    'genre' => URI.encode(params[:genre]),
    'budget' => URI.encode(params[:budget]),
    'start' => 10 * (params[:page].to_i - 1) + 1,
    'format' => 'json'
    }
    uri = URI.parse(@api_list["base"] + '?key=' + @api_key + '&' + uri_para.map{|k,v| "#{k}=#{v}"}.join('&'))
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
    flash[:danger] = "どれか一つ入力して下さい。"
    redirect_to root_path
  end
end



def get_term_api(term)
  uri_para = {
  'format' => 'json'
  }
  uri = URI.parse(@api_list[term] + '?key=' + @api_key + '&' + uri_para.map{|k,v| "#{k}=#{v}"}.join('&'))
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
        @results_researches = @results[term]
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



def get_name_api
  uri_para = {
  'format' => 'json'
  }
  uri = URI.parse(@api_list[term] + '?key=' + @api_key + '&' + uri_para.map{|k,v| "#{k}=#{v}"}.join('&'))
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
        @results_researches = @results[term]
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
