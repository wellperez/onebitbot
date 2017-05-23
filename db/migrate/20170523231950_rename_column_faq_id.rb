class RenameColumnFaqId < ActiveRecord::Migration[5.1]
  def change
    rename_column :faq_link_hashtags, :faq_id, :fl_id
  end
end
