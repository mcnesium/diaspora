class EventEditor < ActiveRecord::Base
  include Diaspora::Federated::Base
  include Diaspora::Guid

  belongs_to :event
  validates :event, presence: true

  belongs_to :editor, :class_name => 'Person'
  validates :editor, presence: true

  validates_uniqueness_of :event, scope: [:editor]

  xml_name :event_editor
  xml_attr :event_guid
  xml_attr :editor_guid
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

  def editor_guid
    self.editor.guid
  end

  def editor_guid= (guid)
    self.editor = Person.find_by_guid(guid)
  end

  def diaspora_handle
    self.event.author.diaspora_handle
  end

  # def diaspora_handle= (handle)
  #   self.editor = Person.find_by_diaspora_handle(handle)
  # end

  # RuntimeError (You must override receive in order to enable federation on this model):
  def receive(u, p)
    self.save
  end

end
