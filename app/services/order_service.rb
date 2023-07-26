class OrderService < SquareService
  def initialize(square_connector, options = {})
    super(square_connector, options)
    @location_id = options[:location_id]
  end

  def call
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
    square_connector.host + "/v2/orders/search"
  end

  def request_body
    {
      location_ids: [@location_id],
      query: {
        filter: {
          date_time_filter: {
            created_at: {
              start_at: start_at + 'T00:00:00Z',
              end_at: end_at + 'T00:00:00Z'
            }
          }
        }
      }
    }.to_json
  end

end
