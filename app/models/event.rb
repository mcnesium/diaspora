class Event < ActiveRecord::Base
  include Diaspora::Federated::Base
  include Diaspora::Guid

  # belongs_to :status_message

  has_many :event_invitations
  has_many :event_participations

  # xml_attr :guid
  # xml_attr :title
  # xml_attr :start
  # xml_attr :end
  # xml_attr :location
  # xml_attr :image

  # forward some requests to status message
  delegate :author, :author_id, :diaspora_handle, :public?, :subscribers, to: :status_message
  # TODO alle eigenschaften, has many event_participation model, belongs_to person, usw

end
