# frozen_string_literal: true

class Project < ApplicationRecord
  belongs_to :user
  has_many :tasks
  has_many :lists

  validates :name, :description, presence: true
end
