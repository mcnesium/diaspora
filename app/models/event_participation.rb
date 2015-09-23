class EventParticipation < ActiveRecord::Base

  belongs_to :event, :foreign_key => :event_guid
  validates :event_guid, presence: true

  belongs_to :person, :foreign_key => :person_guid
  validates :person_guid, presence: true

end
