class EventParticipationsController < ApplicationController
  before_action :authenticate_user!, :only => [:create]
  skip_before_filter :verify_authenticity_token

  def show
    # return given participation
    render :json => EventParticipation.find_by_event_id(params[:id]),
      content_type: "application/json"
  end

  def create
    if params[:event]
      event = Event.find(params[:event])
    else
      render_error(400,"No event given")
      return
    end

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

      # update own attendance if this is me
      if params[:attending] && participant == current_user.person
        participation.attending = params[:attending].to_b
      # update role if provided and user is allowed to
      elsif params[:role]
        if current_user_may_edit(event)
          participation.role = params[:role]
        else
          render_error(403,"You are not allowed to edit this event")
          return
      end
      else
        render_error(400,"Nothing to update")
        return
      end
      # update the participation
      participation.save

    # new participation
    else

      participation = {
        "participant" => participant,
        "event" => event
      }
      # attend to event if this is me
      if participant == current_user.person
        participation["attending"] = 1
      # or set the participation role if provided and user is allowed to
      elsif params[:role] && current_user_may_edit(event)
        participation["role"] = params[:role]
      # otherwise invite that person
      else
        participation["invitor"] = current_user.person
      end
      # create the participation
      EventParticipation.create(participation)

    end

    Postzord::Dispatcher.defer_build_and_post(current_user, participation)
    render :json => participation, content_type: "application/json"

  end

  def current_user_may_edit(event)
    participation = EventParticipation.find_by( event: event, participant: current_user.person )
    if participation && participation.privileged?
      return true
    else
      return false
    end
  end

  def render_error(status,string)
    render :json => { "error": string }, status: status, content_type: "application/json"
  end

end
# TODO Tests

class String
    def to_b()
        self.downcase == "true"
    end
end
