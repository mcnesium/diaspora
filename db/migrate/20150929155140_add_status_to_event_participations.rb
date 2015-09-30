class AddStatusToEventParticipations < ActiveRecord::Migration
  def change
    add_column :event_participations, :status, :integer, default: 0
  end
end
