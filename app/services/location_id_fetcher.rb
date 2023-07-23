class LocationIdFetcher
  attr_accessor :square_connector

  def initialize(square_connector)
    @square_connector = square_connector
  end

  def location_id
    begin
      response = RestClient.get url, headers
      if response.code == 200
        data = JSON.parse response.body
        location_ids = data['locations'].map { |location| location['id'] }
      end

      location_ids&.first
    end
  end

  def url
    "https://connect.squareupsandbox.com/v2/locations"
  end

  def headers
    {
      'Square-Version': '2023-06-08',
      'Authorization': "Bearer #{square_connector.access_token}",
      'Content-Type': 'application/json'
    }
  end
end
