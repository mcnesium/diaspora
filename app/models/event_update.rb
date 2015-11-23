class EventUpdate
  include Diaspora::Federated::Base

  xml_name :event_update
  xml_attr :event
  xml_attr :title
  xml_attr :diaspora_handle

  def subscribers(user)
    user.contact_people
  end

  def receive(receiver, sender)
    event = Event.find_by_guid(self.guid)
    event.title = self.title
    event.save
  end

  attr_accessor :event, :title, :diaspora_handle

  def initialize(attributes = {})
    @event = attributes[:event]
    @title = attributes[:title]
    @diaspora_handle = attributes[:diaspora_handle]
  end

end
