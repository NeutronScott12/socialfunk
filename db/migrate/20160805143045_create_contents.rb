class CreateContents < ActiveRecord::Migration[5.0]
  def change
    create_table :contents do |t|
      t.text :comment
      t.integer :user_id
      t.integer :topic_id

      t.timestamps
    end
  end
end
