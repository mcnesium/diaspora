class EventParticipation < ActiveRecord::Base

  belongs_to :event, :foreign_key => :event, :primary_key => :guid
  validates :event, presence: true

  belongs_to :person, :foreign_key => :person, :primary_key => :guid
  validates :person, presence: true

  # roles a person can have in relation to an event
  enum role: {
      :guest => 0,
      :promoter => 1,
      :owner => 2
  }

  # a relation of a person to an event is privileged if at least promoter role
  def privileged?
    self[:role] >= EventParticipation.roles[:promoter]
  end

  validate :additional_flags

  private

    # check for any of invited, attending or privileged properties
    def additional_flags
      unless self.invited_by? || self.attending? || self.privileged?
        raise "Must include invited_by, attending, or role >= promoter"
      end
    end

end
