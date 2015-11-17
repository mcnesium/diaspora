class CreateEvents < ActiveRecord::Migration
  def up

    create_table :events do |t|
      t.string :title
      t.datetime :start
      t.string :guid
      t.timestamps null: false
    end

    create_table :event_invitations do |t|
      t.belongs_to :invitee, :null => false
      t.belongs_to :event, :null => false
      t.belongs_to :invitor, :null => false
      t.timestamps null: false
    end
    add_index :event_invitations, [:invitee_id, :event_id], unique: true

    create_table :event_attendings do |t|
      t.belongs_to :attendant, :null => false
      t.belongs_to :event, :null => false
      t.boolean :attending
      t.timestamps null: false
    end
    add_index :event_attendings, [:attendant_id, :event_id], unique: true

    create_table :event_roles do |t|
      t.belongs_to :person, :null => false
      t.belongs_to :event, :null => false
      t.integer :role, default: 0
      t.timestamps null: false
    end
    add_index :event_roles, [:person_id, :event_id], unique: true

  end

  def down
    drop_table :events
    drop_table :event_invitations
    remove_index :event_invitations, [:person_id, :event_id]
    drop_table :event_attendings
    remove_index :event_attendings, [:person_id, :event_id]
    drop_table :event_roles
    remove_index :event_roles, [:person_id, :event_id]
  end

end
