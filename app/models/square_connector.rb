class SquareConnector < ApplicationRecord
  def host
    if production
      "https://connect.squareup.com"
    else
      "https://connect.squareupsandbox.com"
    end
  end
end
