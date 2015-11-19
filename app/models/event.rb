class Event < ActiveRecord::Base
  include Diaspora::Federated::Base
  include Diaspora::Guid

  validates :title, length: { minimum: 1, maximum: 255 }
  xml_attr :title
  # xml_attr :start
  # xml_attr :event_participations, :as => [EventParticipation]
  #
  # has_many :event_participations
  #
  # accepts_nested_attributes_for :event_participations
  #
  # validates :start, presence: true

  # RuntimeError (You must override subscribers in order to enable federation on this model)
  def subscribers(user)
    user.contact_people
  end
  def diaspora_handle
  end
  #   # binding.pry
  #   self.owner.diaspora_handle
  # end
  # def owner
  #   # return the person that participation has the owner role
  #   Person.find_by( id: self.event_participations.detect{|role| role = EventParticipation.roles[:owner] }.participant_id )
  # end
  #
  # def receive(user, person)
  #
  #   ev = Event.find_by_guid(self.guid)
  #   if ev
  #     ev.title = self.title
  #     ev.start = self.start
  #     ev.save
  #
  #     return ev
  #   end
  #
  #   for participation in self.event_participations
  #     participation.event=self
  #   end
  #
  #   self.save
  #
  # end

end
