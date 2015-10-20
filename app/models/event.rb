class Event < ActiveRecord::Base
  include Diaspora::Federated::Base
  include Diaspora::Guid

  has_many :event_participations

  xml_attr :title
  xml_attr :start

  validates :title, length: { minimum: 1, maximum: 255 }
  validates :start, presence: true

  def subscribers(user)
    user.contact_people
  end
  def diaspora_handle
    self.owner.diaspora_handle
  end
  def owner
    # byebug
    participation = EventParticipation.find_by(event: self);
    person = Person.find_by(participation.person_id)
    return person
  end
end
