# frozen_string_literal: true

class ReceiverAddress < ApplicationRecord
  belongs_to :shipment

  geocoded_by :state

  after_validation :geocode
end
