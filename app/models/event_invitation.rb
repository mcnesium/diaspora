class EventInvitation < ActiveRecord::Base

  belongs_to :event, :foreign_key => :event_guid
  validates :event_guid, presence: true

  belongs_to :person, :foreign_key => :author_guid
  validates :author_guid, presence: true

  belongs_to :person, :foreign_key => :target_guid
  validates :target_guid, presence: true

end
