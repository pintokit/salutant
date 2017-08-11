class AddIsUnreadToSubmissions < ActiveRecord::Migration[5.1]
  def change
    add_column :submissions, :is_unread, :boolean, default: true
  end
end
