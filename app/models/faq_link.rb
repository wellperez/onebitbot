require "pg_search"
include PgSearch

class FaqLink < ActiveRecord::Base
  validates_presence_of :question, :answer

  enum faq_links_type: [:faq, :link]

  has_many :faq_link_hashtags
  has_many :hashtags, through: :faq_link_hashtags
  belongs_to :company

  # include PgSearch
  pg_search_scope :search, :against => [:question, :answer]
end
