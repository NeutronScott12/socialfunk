class CreateComments < ActiveRecord::Migration[5.0]
  def change
    create_table :comments do |t|
      t.text :content
      t.integer :user_id
      t.integer :micropost_id

      t.timestamps
    end
    add_index :comments, [:user_id, :micropost_id]
  end
end
