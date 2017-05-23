class FaqLinkHashtag < ActiveRecord::Base
  validates_presence_of :fl_id, :hashtag_id

  belongs_to :faq_link
  belongs_to :hashtag
end
