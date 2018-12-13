class CreateJournals < ActiveRecord::Migration[5.2]
  def change
    create_table :journals do |t|
      t.string :title
      t.string :subcategory
      t.integer :user_id
      t.string :text
      t.timestamps
    end
  end
end
