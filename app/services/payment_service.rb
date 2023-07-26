class PaymentService < SquareService
  def url
    square_connector.host + "/v2/payments"
  end

  def name
    "payments"
  end
end