class EventInvitation < ActiveRecord::Base
  include Diaspora::Federated::Base

  belongs_to :event
  validates :event, presence: true

  belongs_to :invitee, :class_name => 'Person'
  validates :invitee, presence: true

  validates_uniqueness_of :event, scope: [:invitee]

  belongs_to :invitor, :class_name => 'Person'
  validates :invitor, presence: true

  xml_name :event_invitation
  xml_attr :event_guid
  xml_attr :invitee_guid
  xml_attr :invitor_guid
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

  def invitee_guid
    self.invitee.guid
  end

  def invitee_guid= (guid)
    self.invitee = Person.find_by_guid(guid)
  end

  def invitor_guid
    self.invitor.guid
  end

  def invitor_guid= (guid)
    self.invitor = Person.find_by_guid(guid)
  end

  def diaspora_handle
    self.invitor.diaspora_handle
  end

  def diaspora_handle= (handle)
    self.invitor = Person.find_by_diaspora_handle(handle)
  end

  # RuntimeError (You must override receive in order to enable federation on this model):
  def receive(u, p)
    self.save
  end

end
