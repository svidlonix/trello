# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    name { Faker::FunnyName.name }
    description { Faker::Community.quotes }
    project
    user
    task_parent { nil }
    list
    position { Faker::Number.number(2) }
  end
end
