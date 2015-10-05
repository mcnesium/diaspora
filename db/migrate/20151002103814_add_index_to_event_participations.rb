class AddIndexToEventParticipations < ActiveRecord::Migration
  def change
    rename_column :event_participations, :person, :person_id

    add_index :event_participations, [:event_id, :person_id], unique: true,
                :length => { :event_id => 32, :person_id => 32 }
  end
end
