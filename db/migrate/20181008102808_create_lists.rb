# frozen_string_literal: true

class CreateLists < ActiveRecord::Migration[5.2]
  def change
    create_table :lists do |t|
      t.string :name
      t.integer :project_id
      t.integer :user_id
      t.integer :position

      t.timestamps
    end

    add_column :tasks, :list_id, :integer
    add_index :lists, :user_id
    add_index :lists, :project_id
    add_index :tasks, :list_id
  end
end
