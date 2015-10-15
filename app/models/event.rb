class Event < ActiveRecord::Base
  include Diaspora::Federated::Base
  include Diaspora::Guid
  # include Diaspora::Shareable

  # belongs_to :status_message

  has_many :event_participations

  # xml_attr :guid
  xml_attr :title
  xml_attr :start
  # xml_attr :end
  # xml_attr :location
  # xml_attr :image

  # forward some requests to status message
  # delegate :author, :author_id, :diaspora_handle, :public?, :subscribers, to: :status_message
  # TODO  Location

  validates :title, length: { minimum: 1, maximum: 255 }
  validates :start, presence: true

  def subscribers(user)
    user.contact_people
  end
  def diaspora_handle
    self.owner.diaspora_handle
  end
  def owner
    self.event_participations.find_by(event: self, role: EventParticipation.roles[:owner]).person
  end
end
