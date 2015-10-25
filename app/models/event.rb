class Event < ActiveRecord::Base
  include Diaspora::Federated::Base
  include Diaspora::Guid

  xml_attr :title
  xml_attr :start
  xml_attr :event_participations, :as => [EventParticipation]

  has_many :event_participations

  accepts_nested_attributes_for :event_participations

  validates :title, length: { minimum: 1, maximum: 255 }
  validates :start, presence: true

  def subscribers(user)
    user.contact_people
  end
  def diaspora_handle
    # binding.pry
    self.owner.diaspora_handle
  end
  def owner
    # return the person that participation has the owner role
    Person.find_by( id: self.event_participations.detect{|role| role = EventParticipation.roles[:owner] }.person_id )
  end

  def receive(user, person)
    for participation in self.event_participations
      participation.event=self
    end
    self.save
  end

end
