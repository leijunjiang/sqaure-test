class LocationIdFetcherService < SquareService
  def location_id
    begin
      response = RestClient.get url, headers
      if response.code == 200
        data = JSON.parse response.body
        location_ids = data['locations'].map { |location| location['id'] }
      end
      p "location_ids ------"
      p location_ids
      location_ids&.last
    end
  end

  def url
    square_connector.host + "/v2/locations"
  end
end
