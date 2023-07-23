class PaymentService
  attr_accessor :square_connector

  def initialize(square_connector)
    @square_connector = square_connector
  end

  def url
    square_connector.host + "/v2/payments"
  end

  def call
    begin
      response = RestClient.get url, headers
      response_json = JSON.parse response

      response_json["payments"]
    end
  end

  def headers
    {
      'authorization' => "Bearer #{square_connector.access_token}",
      'Square-Version' => '2023-06-08',
      'Content-Type' => 'application/json'
    }
  end
end