class AddCallsDoneToClient < ActiveRecord::Migration[5.2]
  def change
    add_column :clients, :calls_done, :bool, default: false
  end
end
