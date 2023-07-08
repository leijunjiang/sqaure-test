class CreateSquareConnectors < ActiveRecord::Migration[6.1]
  def up
    create_table :square_connectors do |t|
      t.string :client_id
      t.string :client_secret
      t.string :access_token
      t.datetime :expired_at
      t.timestamps
    end
  end

  def down
    drop_table :square_connectors
  end
end
