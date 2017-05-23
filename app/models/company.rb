class Company < ActiveRecord::Base
  validates_presence_of :name

  has_many :faq_links
  has_many :hashtags
end
