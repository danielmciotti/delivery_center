class Order::CreateShipmentService < BaseOrderService

  def initialize(order_id, params)
    return unless params.has_key? :shipping

    super
  end

  def execute
    Shipment.create!(params.merge(order: order))
  end

  private

  def permitted_params(params)
    permitted_hash = params.require(:shipping).permit(model_permitted_params)

    permitted_hash.merge(external_code: permitted_hash[:id])
  end

  def model_permitted_params
    %i[id shipment_type date_created]
  end
end
