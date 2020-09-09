class BaseOrderService < BaseService
  attr_accessor :params, :order

  def initialize(order_id, params)
    return if order_id.nil?

    self.params = permitted_params(params)
    self.order = Order.find_by(id: order_id)
  end

  private

  def permitted_params(params)
    # Abstract Method
  end

  def model_permitted_params
    # Abstract Method
  end
end
