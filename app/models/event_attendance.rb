class EventAttendance < ActiveRecord::Base
  include Diaspora::Federated::Base

  belongs_to :event
  validates :event, presence: true

  belongs_to :attendee, :class_name => 'Person'
  validates :attendee, presence: true

  validates_uniqueness_of :event, scope: [:attendee]

end
