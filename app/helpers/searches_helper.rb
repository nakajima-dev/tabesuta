module SearchesHelper
  
  def search_tags_URI(tags_name)
    URI.parse('https://www.instagram.com/explore/tags/' + URI.encode(tags_name))
  end
  
  
  def search_tags_split(shop_name)
    
    new_shop_name = []
    
    shop_name.split.each do |name|
      unless name.include?("店")
        new_shop_name.push(name)
      end
    end
    
    if new_shop_name.length == 1
      
    elsif new_shop_name.length == 2
      new_shop_name.push(new_shop_name[0] + new_shop_name[1])
    elsif new_shop_name.length >= 3
      str_kana = ""
      str_alpha = ""
      new_shop_name.each do |name|
        if japan(name)
          str_kana += name
        else
          str_alpha += name
        end
      end
      unless !str_kana.present?
        new_shop_name.push(str_kana)
      end
      unless !str_alpha.present?
        new_shop_name.push(str_alpha)
      end
    end
    
    return new_shop_name
  end
  
  def japan(s)
   (s =~ /(\p{Hiragana}|\p{Katakana}|[一-龠々])/) == 0
  end
  
  
  
end
