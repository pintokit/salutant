class RemoveFilterResultFromSubmissions < ActiveRecord::Migration[5.1]
  def change
    remove_column :submissions, :filter_result, :integer
  end
end
