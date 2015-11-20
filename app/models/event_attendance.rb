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
  xml_attr :diaspora_handle

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

  def diaspora_handle
    self.attendee.diaspora_handle
  end

  def diaspora_handle= (handle)
    self.attendee = Person.find_by_diaspora_handle(handle)
  end

  # RuntimeError (You must override receive in order to enable federation on this model):
  def receive(u, p)
    self.save
  end

end
