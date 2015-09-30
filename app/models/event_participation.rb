class EventParticipation < ActiveRecord::Base

  belongs_to :event, :foreign_key => :event, :primary_key => :guid
  validates :event, presence: true

  belongs_to :person, :foreign_key => :person, :primary_key => :guid
  validates :person, presence: true

  validate :invited_xor_attending

  enum status: {
      :guest => 0,
      :promoter => 1,
      :owner => 2
  }

  def privileged?
    self[:status] >= EventParticipation.statuses[:promoter]
  end

  private

    def invited_xor_attending # TODO naming
      unless self.invited_by? || self.attending? || self.privileged?
        raise "Must be invited or attending"
      end
    end

end
