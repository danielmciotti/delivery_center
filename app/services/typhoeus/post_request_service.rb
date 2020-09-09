class Typhoeus::PostRequestService < TyphoeusService

  def execute
    Typhoeus.post(url, body: body, headers: headers)
  end

  private

  def headers
    {'X-Sent' => request_time}
  end

  def request_time
    DateTime.now.strftime('%Hh%M - %d/%m/%y')
  end
end
