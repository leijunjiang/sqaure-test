class InvoiceParser
  attr_accessor :invoices

  def initialize(invoices)
    @invoices = invoices
  end

  def assets
    amount = 0

    invoices.each do |invoice|
      next unless invoice["status"] == "UNPAID"
      amount += invoice.dig("next_payment_amount_money", "amount")
    end

    amount
  end
end