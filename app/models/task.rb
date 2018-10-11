# frozen_string_literal: true

class Task < ApplicationRecord
  has_many :assignments
  has_many :users, through: :assignments
  belongs_to :user
  belongs_to :project
  belongs_to :list
  belongs_to :task_parent, class_name: 'Task', optional: true

  validates :name, presence: true

  before_create :fill_position

  default_scope { order(position: :asc) }

  private

  def fill_position
    self.position = list.tasks&.last&.position.to_i + 1
  end
end
