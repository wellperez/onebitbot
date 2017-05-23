class RenameFaq < ActiveRecord::Migration[5.1]
  def change
    rename_table :faqs, :faq_links
  end
end
