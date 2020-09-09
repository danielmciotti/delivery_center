# frozen_string_literal: true

class Order::CreateDeliveryAddressService < BaseOrderService
  attr_accessor :shipment, :params

  def initialize(shipment_id, params)
    return unless params.key? :shipping
    return if shipment_id.nil?

    self.params = permitted_params(params)
    self.shipment = Shipment.find_by(id: shipment_id)
  end

  def execute
    ReceiverAddress.create!(params.merge(shipment: shipment))
  end

  private

  def permitted_params(params)
    params.require(:shipping).require(:receiver_address).permit(model_permitted_params)
  end

  def model_permitted_params
    [
      :id, :address_line, :street_name, :street_number, :comment, :zip_code, :latitude, :longitude, :receiver_phone,
      {
        city: :name,
        state: :name,
        country: %i[id name],
        neighborhood: %i[id name]
      }
    ]
  end
end
