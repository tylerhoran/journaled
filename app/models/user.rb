class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_and_belongs_to_many :journals
  has_many :articles, through: :journals

  def refresh_articles
    journals.each do |j|
      j.refresh
    end
  end
end
