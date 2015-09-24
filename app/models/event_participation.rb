class EventParticipation < ActiveRecord::Base

  belongs_to :event, :foreign_key => :event
  validates :event, presence: true

  belongs_to :person, :foreign_key => :person
  validates :person, presence: true

end
