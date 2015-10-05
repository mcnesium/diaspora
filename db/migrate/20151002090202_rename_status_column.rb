class RenameStatusColumn < ActiveRecord::Migration
  def change
    rename_column :event_participations, :status, :role
  end
end
