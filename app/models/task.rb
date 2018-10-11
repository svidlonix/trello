class Task < ApplicationRecord
  has_many :assignments
  has_many :users, through: :assignments
  belongs_to :user
  belongs_to :project
  belongs_to :task_parent, class_name: 'Task'

  validates :name, :description, presence: true
end
