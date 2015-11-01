class EventRelation < ActiveRecord::Base
  include Diaspora::Federated::Base

  xml_name :event_relation
  xml_attr :event_guid
  xml_attr :targetperson_guid
  xml_attr :invitor_guid
  xml_attr :attending
  xml_attr :role

  belongs_to :event
  validates :event, presence: true

  belongs_to :targetperson, :class_name => 'Person'
  validates :targetperson, presence: true

  belongs_to :invitor, :class_name => 'Person'

  validates_uniqueness_of :event, scope: [:targetperson]

  # roles a person can have in relation to an event
  enum role: {
      :guest => 0,
      :editor => 1,
      :owner => 2
  }

  # a relation of a person to an event has extended permissions
  def may_edit?
    self[:role] >= EventRelation.roles[:editor]
  end
  def is_owner?
    self[:role] >= EventRelation.roles[:owner]
  end

  # validate :additional_flags

  def diaspora_handle

    self.targetperson.diaspora_handle

    # if self.invitor
    #   self.invitor.diaspora_handle
    # else
    #   self.diaspora_handle
    # end
  end

  def receive(user, person)

    # check if this is an existing relation
    if relation = EventRelation.find_by( event: self.event, targetperson: self.targetperson)
      relation.attending = self.attending
      relation.invitor = self.invitor
      relation.role = self.role
      relation.save

      return relation
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

  def targetperson_guid
    self.targetperson.guid
  end

  def targetperson_guid= (guid)
    self.targetperson = Person.find_by_guid(guid)
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
      unless self.invitor? || self.attending? || self.may_edit?
        raise "Must include invitor, attending, or role >= promoter"
      end
    end

end
