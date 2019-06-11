class RemoveRecordingFromClient < ActiveRecord::Migration[5.2]
  def change
    remove_column :clients, :recording, :string
  end
end
