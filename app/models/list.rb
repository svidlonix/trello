# frozen_string_literal: true

class List < ApplicationRecord
  belongs_to :project
  belongs_to :user
  has_many :tasks

  validates :name, presence: true

  default_scope { order(position: :asc) }

  before_create :fill_position

  private

  def fill_position
    self.position = project.lists&.last&.position.to_i + 1
  end
end
