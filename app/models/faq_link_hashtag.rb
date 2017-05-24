class FaqLinkHashtag < ActiveRecord::Base
  validates_presence_of :faq_link_id, :hashtag_id

  belongs_to :faq_link
  belongs_to :hashtag
end
