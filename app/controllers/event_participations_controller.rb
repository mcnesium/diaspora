class EventParticipationsController < ApplicationController
  before_action :authenticate_user!, :only => [:create]
  skip_before_filter :verify_authenticity_token

  def show
    # return given participation
    render :json => EventParticipation.find_by_event_id(params[:id]),
      content_type: "application/json"
  end

  def create
    event = Event.find(params[:event])

    # check if this is about me or another participant
    if params[:particpant]
        participant = Person.find(params[:participant])
    else
        participant = current_user.person
    end

    # find an already existing participation
    participation = EventParticipation.find_by(event:event,participant:participant)
    
    # existing participation
    if participation

      # update own attendance
      if params[:attending] && participant == current_user.person
        participation.attending = params[:attending].to_b
        participation.save
      end

      # update role
      if params[:role]
        # check if current user participation is privileged
        if EventParticipation
            .find_by( event: event, participant: current_user.person )
            .privileged?
          participation.role = params[:role]
          participation.save
        end
      end

    # new participation
    else

      # attend to event, if this is me
      if participant == current_user.person
        participation = EventParticipation.create(
          participant: participant,
          event: event,
          attending: 1,
          # role: EventParticipation.roles[:guest],
        )
      # otherwise invite that person
      else
        participation = EventParticipation.create(
          participant: participant,
          event: event,
          invitor: current_user.person,
          # role: EventParticipation.roles[:guest],
        )
      end

    end
    Postzord::Dispatcher.defer_build_and_post(current_user, participation)
    render :json => participation, content_type: "application/json"

  end

end
# TODO Tests

class String
    def to_b()
        self.downcase == "true"
    end
end