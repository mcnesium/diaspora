class EventUpdate
  include Diaspora::Federated::Base

  xml_name :event_update

  xml_attr :event
  xml_attr :title
  xml_attr :diaspora_handle

  attr_accessor :event, :title, :diaspora_handle

  def initialize(attributes = {})
    @event = attributes[:event]
    @title = attributes[:title]
    @diaspora_handle = attributes[:diaspora_handle]
  end

  def receive(receiver, sender)
    event = Event.find_by_guid(self.event)
    event.title = self.title
    event.save
  end

  # RuntimeError (You must override subscribers in order to enable federation on this model)
  def subscribers(user)
    user.contact_people
  end

end
