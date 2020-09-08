# frozen_string_literal: true

FactoryBot.define do
  factory :buyer do
    external_code { 'MyString' }
    nickname { 'MyString' }
    first_name { 'MyString' }
    last_name { 'MyString' }
    phone { '' }
    billing_info { '' }
  end
end
