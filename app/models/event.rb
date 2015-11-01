class Event < ActiveRecord::Base
  include Diaspora::Federated::Base
  include Diaspora::Guid

  xml_attr :title
  xml_attr :start
  xml_attr :event_relations, :as => [EventRelation]

  has_many :event_relations

  accepts_nested_attributes_for :event_relations

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
    # return the person that relation has the owner role
    Person.find_by( id: self.event_relations.detect{|role| role = EventRelation.roles[:owner] }.target_id )
  end

  def receive(user, person)

    ev = Event.find_by_guid(self.guid)
    if ev
      ev.title = self.title
      ev.start = self.start
      ev.save

      return ev
    end

    for relation in self.event_relations
      relation.event=self
    end

    self.save

  end

end
