# frozen_string_literal: true

FactoryBot.define do
  factory :item do
    externalCode { 'MyString' }
    title { 'MyString' }
    order_item { nil }
  end
end
