class OrderService
  attr_accessor :square_connector

  def initialize(square_connector, location_id, options = {})
    @square_connector = square_connector
    @location_id = location_id
    @options = options
  end

  def list_orders
    begin
      response = RestClient.post url, request_body, headers
      if response.code == 200
        data = JSON.parse(response.body)
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
      'authorization' => "Bearer #{square_connector.access_token}",
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
