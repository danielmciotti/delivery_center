class Order::CreateBuyerService < BaseOrderService

  def initialize(order_id, params)
    return unless params.has_key? :buyer

    super
  end

  def execute
    Buyer.create!(params.merge(order: order))
  end

  private

  def permitted_params(params)
    permitted_hash = params.require(:buyer).permit(model_permitted_params)

    permitted_hash.merge(external_code: permitted_hash[:id])
  end

  def model_permitted_params
    [
      :id, :nickname, :email, :phone, :first_name, :last_name, :billing_info,
      {
        phone: %i[area_code number],
        billing_info: %i[doc_type doc_number]
      }
    ]
  end
end
