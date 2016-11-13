class CreateSubmissions < ActiveRecord::Migration[5.0]
  def change
    create_table :submissions do |t|
      t.string :name
      t.string :email, null: false
      t.jsonb :content, default: '{}'

      t.timestamps
    end
  end
end
