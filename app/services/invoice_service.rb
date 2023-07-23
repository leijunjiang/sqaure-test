class InvoiceService
  attr_accessor :square_connector, :location_id

  def initialize(square_connector, location_id)
    @square_connector = square_connector
    @location_id = location_id
  end

  def url 
    square_connector.host + "/v2/invoices" + "?location_id=#{location_id}"
  end

  def call
    begin
      response = RestClient.get url, headers
      response_json = JSON.parse response

      response_json["invoices"]
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