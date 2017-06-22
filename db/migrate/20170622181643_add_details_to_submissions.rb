class AddDetailsToSubmissions < ActiveRecord::Migration[5.1]
  def change
    rename_column :submissions, :name, :author
    rename_column :submissions, :email, :author_email
    add_column :submissions, :filter_status, :integer, default: 0
    add_column :submissions, :user_ip, :inet
    add_column :submissions, :user_agent, :string
    add_column :submissions, :referrer, :string
  end
end
