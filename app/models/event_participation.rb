class EventParticipation < ActiveRecord::Base
  include Diaspora::Federated::Base
  # include Diaspora::Relayable

  xml_name :event_participation
  xml_attr :event_guid
  xml_attr :participant_guid
  xml_attr :invitor_guid
  xml_attr :attending
  xml_attr :role

  belongs_to :event
  validates :event, presence: true

  belongs_to :participant, :class_name => 'Person'
  validates :participant, presence: true

  belongs_to :invitor, :class_name => 'Person'

  validates_uniqueness_of :event, scope: [:participant]

  # roles a person can have in relation to an event
  enum role: {
      :guest => 0,
      :editor => 1,
      :owner => 2
  }

  # a relation of a person to an event is privileged if at least editor role
  def privileged?
    self[:role] >= EventParticipation.roles[:editor]
  end

  # validate :additional_flags

  def diaspora_handle
    self.invitor.diaspora_handle
  end

  # def diaspora_handle= person_id
  #   self.invitor = Person.find_or_fetch_by_identifier(person_id)
  # end

  # def parent
  #   self.event
  # end

  # def parent= parent
  #   self.event = parent
  # end

  def receive(user, person)
    ep = EventParticipation.find_by(event:event,invitor:person)
    if ep
      ep.attending = self.attending
      ep.invitor = self.invitor
      ep.role = self.role
      ep.save

      return ep
    end

    self.save
  end

  def subscribers(user)
    self.event.subscribers(user)
  end

  def event_guid
    self.event.guid
  end

  def event_guid= (guid)
    self.event = Event.find_by_guid(guid)
  end

  def participant_guid
    self.participant.guid
  end

  def participant_guid= (guid)
    self.participant = Person.find_by_guid(guid)
  end

  def invitor_guid
    if self.invitor
      self.invitor.guid
    end
  end

  def invitor_guid= (guid)
    self.invitor = Person.find_by_guid(guid)
  end

  private

    # check for any of invited, attending or privileged properties
    def additional_flags
      unless self.invitor? || self.attending? || self.privileged?
        raise "Must include invitor, attending, or role >= promoter"
      end
    end

end
