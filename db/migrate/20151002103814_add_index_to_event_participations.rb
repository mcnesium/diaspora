class AddIndexToEventParticipations < ActiveRecord::Migration
  def change
    add_index :event_participations, [:event, :person], unique: true,
              :length => { :event => 32, :person => 32 }
  end
end
