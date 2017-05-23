class RenameFaqHashtags < ActiveRecord::Migration[5.1]
  def change
    rename_table :faq_hashtags, :faq_link_hashtags
  end
end
