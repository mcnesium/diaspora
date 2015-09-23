class CreateEvents < ActiveRecord::Migration
  def change

    create_table :events do |t|
      t.string :guid
      t.string :title
      t.datetime :start

      t.timestamps null: false
    end

    create_table :event_participations do |t|
      t.string :person_guid
      t.string :event_guid

      t.timestamps null: false
    end

    create_table :event_invitations do |t|
      t.string :author_guid
      t.string :target_guid
      t.string :event_guid

      t.timestamps null: false
    end

  end
end
