class EventAttendance < ActiveRecord::Base
  include Diaspora::Federated::Base

  belongs_to :event
  validates :event, presence: true

  belongs_to :attendee, :class_name => 'Person'
  validates :attendee, presence: true

  validates_uniqueness_of :event, scope: [:attendee]

  xml_name :event_attendance
  xml_attr :event_guid
  xml_attr :attendee_guid

  # RuntimeError (You must override subscribers in order to enable federation on this model)
  def subscribers(user)
    user.contact_people
  end

  def event_guid
    self.event.guid
  end

  def event_guid= (guid)
    self.event = Event.find_by_guid(guid)
  end

  def attendee_guid
    self.attendee.guid
  end

  def attendee_guid= (guid)
    self.attendee = Person.find_by_guid(guid)
  end

end
