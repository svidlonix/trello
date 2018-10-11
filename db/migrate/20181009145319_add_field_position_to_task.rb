# frozen_string_literal: true

class AddFieldPositionToTask < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :position, :integer
    add_index :tasks, :position
    add_index :lists, :position
  end
end
