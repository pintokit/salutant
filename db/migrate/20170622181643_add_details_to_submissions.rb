class AddDetailsToSubmissions < ActiveRecord::Migration[5.1]
  def change
    add_column :submissions, :filter_result, :integer
  end
end
