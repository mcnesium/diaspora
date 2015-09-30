class EventParticipation < ActiveRecord::Base

  belongs_to :event, :foreign_key => :event
  validates :event, presence: true

  belongs_to :person, :foreign_key => :person
  validates :person, presence: true

  # validate :invited_xor_attending

  enum status: [ :guest, :promoter, :owner ]

  private

    def invited_xor_attending
      unless self.invited_by? || self.attending?
      # unless self.invited_by? || self.attending? || self.status.promoter?
      # unless self.invited_by? || self.attending? || ( self.status.promoter? || self.status.owner? )
        raise "Must be invited or attending"
      end
    end


end
