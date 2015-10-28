class RenamePerson < ActiveRecord::Migration
  def change
    rename_column :event_participations, :person_id, :participant_id
  end
end
