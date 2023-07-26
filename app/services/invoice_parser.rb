class InvoiceParser
  attr_accessor :invoices

  def initialize(invoices, date)
    @invoices = invoices
    @date = date
  end


  def assets
    amount = 0

    invoices.each do |invoice|
      if @date < invoice.dig("payment_requests")&.first.dig("due_date") && invoice["status"] == "UNPAID"
        amount += invoice.dig("next_payment_amount_money", "amount")
      end 
    end

    amount
  end
end