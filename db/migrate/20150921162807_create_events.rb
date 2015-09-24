class CreateEvents < ActiveRecord::Migration
  def change

    create_table :events do |t|
      t.string :guid
      t.string :title
      t.datetime :start

      t.timestamps null: false
    end

    create_table :event_participations do |t|
      t.string :person
      t.string :event
      t.string :invited_by
      t.boolean :attending

      t.timestamps null: false
    end

  end
end
