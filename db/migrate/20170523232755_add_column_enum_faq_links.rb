class AddColumnEnumFaqLinks < ActiveRecord::Migration[5.1]
  def change
    add_column :faq_links, :faq_links_type, :integer
  end
end
