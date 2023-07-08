class SquareService
  def initialize(square_connector, authorization_code)
    @square_connector = square_connector
    @authorization_code = authorization_code
  end

  def call
    begin
      response = RestClient.post 'https://connect.squareupsandbox.com/oauth2/token', body, headers
      response_json = JSON.parse response
      if response_json
        @square_connector.update(
          access_token: response_json["access_token"],
          refresh_token: response_json["refresh_token"],
          expired_at: response_json["expires_at"]
        )
      end
    end
  end

  def headers
    { content_type: "application/json", square_version: "2023-06-08" }
  end

  def body
    {
      'client_id' => @square_connector.client_id,
      'client_secret' => @square_connector.client_secret,
      'code' => @authorization_code,
      'grant_type' => 'authorization_code'
    }.to_json
  end
end
