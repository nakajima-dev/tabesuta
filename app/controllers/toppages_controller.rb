# 以下のrequireは、railsの自動require機能により不要になる(!)
require 'net/http'
require 'uri'
require 'json'
require 'api_method'

class ToppagesController < ApplicationController
  
before_action ->{
  api_list
  term_list
  api_key
  term_list_name
}

  def index
    (0..(@term_list.length - 1)).each do |i|
      get_term_api(@term_list.keys[i])
      (0..(@results_available - 1)).each do |j|
        @term_list[@term_list.keys[i]].push([@results_researches[j]["name"], @results_researches[j]["code"]])
      end
    end
  end
  
  private
  
  def search_params
    params.permit(:large_area, :genre, :budget, :keyword, :page)
  end
  

  
  
end
