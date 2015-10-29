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
    if params[:participant]
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
      if params[:role] && is_user_privileged(event,current_user.person)
        participation.role = params[:role]
        participation.save
      end

    # new participation
    else
      participation = {
        "participant" => participant,
        "event" => event
      }

      # attend to event, if this is me
      if participant == current_user.person
        participation["attending"] = 1

      elsif params[:role] && is_user_privileged(event,current_user.person)
        participation["role"] = params[:role]

      # otherwise invite that person
      else
        participation["invitor"] = current_user.person
      end
      EventParticipation.create(participation)

    end
    Postzord::Dispatcher.defer_build_and_post(current_user, participation)
    render :json => participation, content_type: "application/json"

  end

  def is_user_privileged(event,person)
    # check if current user participation is privileged
    current = EventParticipation.find_by( event: event, participant: person )
    if current && current.privileged?
      return true
    else
      render :json => { "error": "You are not allowed to change that role" },
                        status: 403,
                        content_type: "application/json"
    end

  end

end
# TODO Tests

class String
    def to_b()
        self.downcase == "true"
    end
end
