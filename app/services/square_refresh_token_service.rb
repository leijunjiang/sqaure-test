class SquareRefreshTokenService
	attr_accessor :square_connector

	def initialize(square_connector, **options)
		@square_connector = square_connector
		@options = options
	end

	def url
		square_connector.host + '/oauth2/token'
	end

	def call
		begin
      response = RestClient.post  url, body, headers
      response_json = JSON.parse response
      if response_json
        square_connector.update(
          access_token: response_json["access_token"],
          refresh_token: response_json["refresh_token"],
          expired_at: response_json["expires_at"]
        )
      end
    end
	end

	def body
    {
      'client_id' => square_connector.client_id,
      'client_secret' => square_connector.client_secret,
      'grant_type' => 'refresh_token',
      'refresh_token' => square_connector.refresh_token
    }.to_json
  end

	def headers
    { content_type: "application/json", square_version: "2023-07-20" }
  end
end