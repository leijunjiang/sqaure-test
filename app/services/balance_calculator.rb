class BalanceCalculator
  def initialize(revenue, tips, liabilities, assets, adjustments)
    @revenue     = revenue     || 0
    @tips        = tips        || 0
    @liabilities = liabilities || 0
    @assets      = assets      || 0
    @adjustments = adjustments || 0
  end

  def calculate
    balanced_amount = (@revenue + @tips + @liabilities + @assets) - @adjustments
    if balanced_amount == 0
      "True"
    else
      balanced_amount
    end
  end
end
