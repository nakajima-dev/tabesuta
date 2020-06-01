module SearchesHelper
  
  def search_tags_URI(tags_name)
    URI.parse('https://www.instagram.com/explore/tags/' + URI.encode(tags_name))
  end
end
