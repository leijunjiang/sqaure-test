class PaymentParser
  attr_accessor :payments

  def initialize(payments)
    @payments = payments
  end

  def payment_processors
    revenue_per_processor = Hash.new(0)

    payments.each do |payment|
      amount = payment.dig("amount_money", "amount")
      processor_name = payment.dig("card_details", "card", "card_brand")
      revenue_per_processor[processor_name] += amount
    end

    revenue_per_processor
  end

  def adjustments
    payments.inject(0) {|sum, payment| sum += payment.dig("amount_money", "amount")}
  end
end