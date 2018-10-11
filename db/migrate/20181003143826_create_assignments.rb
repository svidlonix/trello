# frozen_string_literal: true

class CreateAssignments < ActiveRecord::Migration[5.2]
  def change
    create_table :assignments do |t|
      t.integer :user_id
      t.integer :task_id

      t.timestamps
    end

    add_index :assignments, %i[user_id task_id]
  end
end
