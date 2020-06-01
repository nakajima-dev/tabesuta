class User < ApplicationRecord
  before_save { self.email.downcase! }
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
  validates :birth_date, presence: true
  validates :password, presence: true
  has_secure_password
  
  has_many :shops, dependent: :destroy
  
  
  def fav_shop?(number)
    self.shops.exists?(number: number)
  end
  
end
