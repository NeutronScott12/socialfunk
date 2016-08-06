class CreateTopics < ActiveRecord::Migration[5.0]
  def change
    create_table :topics do |t|
      t.string :title
      t.text :description
      t.integer :user_id
      t.integer :forum_id

      t.timestamps
    end
  end
end
