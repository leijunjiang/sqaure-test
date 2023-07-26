class InvoiceService < SquareService
  def initialize(square_connector, options = {})
    super(square_connector, options)
    @location_id = options[:location_id]
  end

  def url 
    square_connector.host + "/v2/invoices" + "?location_id=#{@location_id}"
  end

  def name
    "invoices"
  end
end