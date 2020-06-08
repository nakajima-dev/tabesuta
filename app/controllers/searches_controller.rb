# 以下のrequireは、railsの自動require機能により不要になる(!)
require 'net/http'
require 'uri'
require 'json'
require 'api_method'

class SearchesController < ApplicationController
  
  
  before_action :require_user_logged_in
  before_action ->{
    api_list
    term_list
    term_list_name
    api_key
  }

  def show
    # 検索項目をAPIで表示
    (0..(@term_list.length - 1)).each do |i|
      get_term_api(@term_list.keys[i])
      (0..(@results_available - 1)).each do |j|
        @term_list[@term_list.keys[i]].push([@results_researches[j]["name"], @results_researches[j]["code"]])
      end
    end
    # 得られたパラメータから条件検索
    get_api
    (0..(@term_list.length - 1)).each do |i|
      (0..(@term_list[@term_list.keys[i]].length - 1)).each do |j|
        # binding.pry
        if @term_list[@term_list.keys[i]][j].include?(params[@term_list.keys[i]])
          @term_list_name[@term_list.keys[i]].push(@term_list[@term_list.keys[i]][0][0], @term_list[@term_list.keys[i]][j][0])
        end
      end
    end
    @term_list_name["keyword"].push("キーワード", params["keyword"])
    (0..(@term_list_name.length - 1)).each do |i|
      if @term_list_name[@term_list_name.keys[i]][0]==@term_list_name[@term_list_name.keys[i]][1]
        @term_list_name[@term_list_name.keys[i]][1] = ""
      end
    end
    # binding.pry
  end
  
  
  
  
  
  private
  # Strong Parameter
  def search_params
    # params.permit(:large_area, :genre, :budget, :keyword, :page)
  end
  
end
