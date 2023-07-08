class AddRefreshTokenToSquareConnector < ActiveRecord::Migration[6.1]
  def change
    add_column :square_connectors, :refresh_token, :string
  end
end
