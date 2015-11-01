class CreateEvents < ActiveRecord::Migration
  def up

    create_table :events do |t|
      t.string :title
      t.datetime :start
      t.string :guid
      t.timestamps null: false
    end

    create_table :event_relations do |t|
      t.belongs_to :target, :null => false
      t.belongs_to :event, :null => false
      t.belongs_to :invitor
      t.boolean :attending
      t.integer :role, default: 0
      t.timestamps null: false
    end

    add_index :event_relations, [:event_id, :target_id], unique: true,
                :length => { :event_id => 32, :target_id => 32 }
  end

  def down
    drop_table :events
    drop_table :event_relations
    remove_index :event_relations, [:event_id, :target_id]
  end

end
