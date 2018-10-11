class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.string :name
      t.text :description
      t.integer :project_id
      t.integer :user_id
      t.integer :task_parent_id

      t.timestamps
    end

    add_index :tasks, :user_id
    add_index :tasks, :task_parent_id
    add_index :tasks, :project_id
  end
end
