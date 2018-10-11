class CreateProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :projects do |t|
      t.string :name
      t.text :description
      t.integer :user_id

      t.timestamps
    end

    add_index :projects, :user_id
  end
end
