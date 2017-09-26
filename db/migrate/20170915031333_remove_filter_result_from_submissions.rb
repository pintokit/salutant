class RemoveFilterResultFromSubmissions < ActiveRecord::Migration[5.1]
  def change
    remove_column :submissions, :filter_result, :integer
    remove_column :submissions, :headers, :jsonb
  end
end
