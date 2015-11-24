class Event < ActiveRecord::Base
  include Diaspora::Federated::Base
  include Diaspora::Guid

  belongs_to :author, :class_name => 'Person'

  validates :author, presence: true
  validates :title, length: { minimum: 1, maximum: 255 }

  xml_attr :diaspora_handle
  xml_attr :title

  # xml_attr :start

  has_many :event_attendances
  has_many :event_invitations
  has_many :event_editors

  accepts_nested_attributes_for :event_attendances
  accepts_nested_attributes_for :event_invitations
  accepts_nested_attributes_for :event_editors

  # validates :start, presence: true

  # RuntimeError (You must override subscribers in order to enable federation on this model)
  def subscribers(user)
    user.contact_people
  end

  def diaspora_handle
      self.author.diaspora_handle
  end

  def diaspora_handle= (handle)
    self.author = Person.find_by_diaspora_handle(handle)
  end

  # RuntimeError (You must override receive in order to enable federation on this model):
  def receive(user, person)

    event = Event.find_by_guid(self.guid)
    if event
      event.title = self.title
      event.author = person
      event.save

      return event
    end

    self.save

  end

end
