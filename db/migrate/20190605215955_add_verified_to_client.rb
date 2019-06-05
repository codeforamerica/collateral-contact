class AddVerifiedToClient < ActiveRecord::Migration[5.2]
  def change
    add_column :clients, :verified, :bool, default: false
  end
end
