# frozen_string_literal: true

FactoryBot.define do
  factory :payment do
    externalCode { 'MyString' }
    installments { 1 }
    transaction_amount { 1.5 }
    taxes_amount { 1.5 }
    shipping_cost { 1.5 }
    total_paid_amount { 1.5 }
    installment_amount { 1.5 }
    date_approved { '2020-09-08 19:42:34' }
    date_created { '2020-09-08 19:42:34' }
  end
end
