class EventUpdate
  include Diaspora::Federated::Base

  xml_name :event_update
  xml_attr :event
  xml_attr :title
  xml_attr :diaspora_handle

  attr_accessor :diaspora_handle

  def subscribers(user)
    user.contact_people
  end

  def receive(receiver, sender)
byebug
  end

  attr_accessor :event, :title

  def initialize(attributes = {})
    @event = attributes[:event]
    @title = attributes[:title]
  end

end
