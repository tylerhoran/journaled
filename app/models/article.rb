class Article < ApplicationRecord
  belongs_to :journal
  has_many :users, through: :journal
  validates :name, presence: true
  validates :author, presence: true
  validates :doi, uniqueness: true
end
