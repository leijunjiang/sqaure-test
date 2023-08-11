class LocationIdFetcherService < SquareService
  def location_id
    begin
      response = RestClient.get url, headers
      if response.code == 200
        data = JSON.parse response.body
        location = data['locations'].last
        p '////////// location'
        p location
        [location["id"], location["name"]]
      end
    end
  end

  def url
    square_connector.host + "/v2/locations"
  end
end
