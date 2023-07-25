class OrderParser
  attr_accessor :orders

  def initialize(orders)
    @orders = orders
  end

  def order_ids
    orders.map {|order| order["id"]}
  end

  def revenue_categories
    revenue_per_product = Hash.new(0)

    orders&.each do |order|
      order["line_items"]&.each do |line_item|
        product_name = line_item["name"]
        next unless product_name
        quantity = line_item["quantity"].to_i
        price = line_item["gross_sales_money"]["amount"]
        revenue = quantity * price
        revenue_per_product[product_name] += revenue
      end
    end

    revenue_per_product
  end

  def taxes
    orders.inject(0){|sum, order| sum += order["total_tax_money"]["amount"]}
  end

  def tips
    orders.inject(0){|sum, order| sum += order["total_tip_money"]["amount"]}
  end

  def liabilities
    orders.inject(0){|sum, order| sum += order["total_money"]["amount"]}
  end
end
