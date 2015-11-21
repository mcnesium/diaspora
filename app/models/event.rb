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

  accepts_nested_attributes_for :event_attendances
  accepts_nested_attributes_for :event_invitations

  # validates :start, presence: true

  # RuntimeError (You must override subscribers in order to enable federation on this model)
  def subscribers(user)
    user.contact_people
  end

  def editor= (editor)
    self.editor = editor
  end

  def diaspora_handle
    if self.editor
      self.editor.diaspora_handle
    else
      self.author.diaspora_handle
    end

  end

  def diaspora_handle= (handle)
    self.author = Person.find_by_diaspora_handle(handle)
  end

  # def owner
  #   # return the person that participation has the owner role
  #   Person.find_by( id: self.event_participations.detect{|role| role = EventParticipation.roles[:owner] }.participant_id )
  # end

  # RuntimeError (You must override receive in order to enable federation on this model):
  def receive(user, person)

    event = Event.find_by_guid(self.guid)
    if event
      event.title = self.title
      event.author = person
      event.save

      return event
    end

    # for participation in self.event_participations
    #   participation.event=self
    # end

    self.save

  end

end
