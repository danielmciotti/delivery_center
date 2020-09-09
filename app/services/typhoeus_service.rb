class TyphoeusService < BaseService
  attr_accessor :body

  def initialize(body = {})
    self.body = body
  end

  private

  def request_time
    DateTime.now.strftime('%Hh%M - %d/%m/%y')
  end

  def url
    ENV['DELIVERY_CENTER_ENDPOINT']
  end

  def headers
    # Abstract Method
  end
end
