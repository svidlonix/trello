class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.text :body
      t.integer :user_id
      t.integer :task_id

      t.timestamps
    end

    add_index :comments, :user_id
    add_index :comments, :task_id
    add_index :comments, :created_at
  end
end
