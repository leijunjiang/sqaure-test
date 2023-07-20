class OrderParser
  attr_accessor :orders

  def initalize(orders)
    @orders = orders
  end

  def order_ids

  end

  def revenue_categories
    revenue_per_product = Hash.new(0)

    line_items = orders["line_items"]
    orders&.each do |order|
      order["line_items"]&.each do |line_item|
        product_name = line_item["name"]
        next unless product_name
        quantity = line_item["quantity"].to_i
        price = line_item["gross_sales_money"]["amount"] / 100
        revenue = quantity * price
        revenue_per_product[product_name] += revenue
      end
    end

    revenue_per_product
  end

  def tax_categories
    orders.inject(0){|sum, order| sum += order["total_tax_money"]["amount"]}
  end

  def tips
    orders.inject(0){|sum, order| sum += order["total_tip_money"]["amount"]}
  end

  def liabilities

  end
end
