class AddProductionToSquareConnector < ActiveRecord::Migration[6.1]
  def change
    add_column :square_connectors, :production, :boolean, default: false
  end
end
