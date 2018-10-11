# frozen_string_literal: true

FactoryBot.define do
  factory :list do
    name { Faker::FunnyName.name }
    project
    user
    position { Faker::Number.number(100) }
  end
end
