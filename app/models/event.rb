class Event < ActiveRecord::Base
  include Diaspora::Federated::Base
  include Diaspora::Guid

  xml_attr :title
  xml_attr :start
  xml_attr :event_participations, :as => [EventParticipation]

  has_many :event_participations

  validates :title, length: { minimum: 1, maximum: 255 }
  validates :start, presence: true

  def subscribers(user)
    user.contact_people
  end
  def diaspora_handle
    self.owner.diaspora_handle
  end
  def owner
    binding.pry
    participation = EventParticipation.find_by(event: self);
    person = Person.find_by(participation.person_id)
    return person
    # event_participations.where(role: "owner").first.person
  end
end
