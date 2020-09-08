# frozen_string_literal: true

class Item < ApplicationRecord
  belongs_to :order_item
end
