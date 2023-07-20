class OrderService
  def initialize(access_token, location_id, options = {})
    @access_token = access_token
    # @access_token = "EAAAEJHatgHDNjIaLwCkB1n96wXF1YIx7qHmL1LsdMNZfT01v3PA7Fh_7MDv_pBe"
    @location_id = location_id
    @options = options
  end

  def list_orders
    begin
      # byebug
      response = RestClient.post url, request_body, headers
      if response.code == 200
        data = JSON.parse(response.body)
        byebug
        @orders = data['orders']
      else
        @error_message = data['errors'].first['detail']
      end
    end

    [@orders, @error_message]
  end

  def url
    "https://connect.squareupsandbox.com/v2/orders/search"
  end

  def headers
    {
      'authorization' => "Bearer #{@access_token}",
      'Square-Version' => '2023-06-08',
      'Content-Type' => 'application/json'
    }
  end

  def request_body
    {
      location_ids: [@location_id],
      query: {
        filter: {
          date_time_filter: {
            created_at: {
              start_at: @options[:start_date] + 'T00:00:00Z',
              end_at: @options[:end_date] + 'T00:00:00Z'
            }
          }
        }
      }
    }.to_json
  end

end
