class Hashtag < ActiveRecord::Base
  validates_presence_of :name
  belongs_to :company


  has_many :faq_link_hashtags
  has_many :faq_links, through: :faq_link_hashtags
end
