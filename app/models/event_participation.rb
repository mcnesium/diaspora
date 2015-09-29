class EventParticipation < ActiveRecord::Base

  belongs_to :event, :foreign_key => :event
  validates :event, presence: true

  belongs_to :person, :foreign_key => :person
  validates :person, presence: true

  validate :invited_xor_attending

  private

    def invited_xor_attending
      if !(self.invited_by? ^ self.attending?)
        raise "Must be invited or attending"
      end
    end

end
