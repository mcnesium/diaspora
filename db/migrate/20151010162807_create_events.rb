class CreateEvents < ActiveRecord::Migration
  def change

    create_table :events do |t|
      t.string :guid
      t.string :title
      t.datetime :start

      t.timestamps null: false
    end

    create_table :event_participations do |t|
      t.string :person_id
      t.string :event
      t.string :invited_by
      t.boolean :attending
      t.integer :role, default: 0

      t.timestamps null: false
    end

    add_index :event_participations, [:event_id, :person_id], unique: true,
                :length => { :event_id => 32, :person_id => 32 }
  end
end
