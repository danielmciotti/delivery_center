# frozen_string_literal: true

class Order::CreateOrderItemsService < BaseOrderService
  def initialize(order_id, params)
    return unless params.key? :order_items

    super
  end

  def execute
    OrderItem.create!(params.map { |oip| oip.merge(order: order) })
  end

  private

  def permitted_params(params)
    params.require(:order_items).collect do |order_item|
      permitted_hash = order_item.permit(model_permitted_params)

      permitted_hash.merge(item: {external_code: permitted_hash[:item][:id], title: permitted_hash[:item][:title]})
    end
  end

  def model_permitted_params
    [
      :quantity, :unit_price, :full_unit_price,
      {
        item: %i[id title]
      }
    ]
  end
end
