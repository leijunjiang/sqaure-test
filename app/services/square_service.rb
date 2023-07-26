class SquareService
  attr_accessor :square_connector,:options

  def initialize(square_connector, options = {})
    @square_connector = square_connector
    @options = options
  end

  def start_at
    options[:date]
  end

  def end_at
    return nil unless start_at
    Date.parse(options[:date]).next_day.strftime
  end

  def call
    begin
      response = RestClient.get url, headers
      response_json = JSON.parse response

      filtered_by_date(response_json["#{name}"])
    end
  end

  def filtered_by_date(response)
    if start_at 
      response.select do |payment|
        payment["created_at"] >= start_at && payment["created_at"] <= end_at
      end
    else
      response
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