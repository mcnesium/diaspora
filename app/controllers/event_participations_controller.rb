class EventParticipationsController < ApplicationController
  before_action :authenticate_user!, :only => [:create]
  skip_before_filter :verify_authenticity_token

  def show
    # return given participation
    render :json => EventParticipation.find_by_event_id(params[:id]),
      content_type: "application/json"
  end

  def create
      byebug
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

      # update own attendance if this is me
      if params[:attending] && participant == current_user.person
        participation.attending = params[:attending].to_b
      end
      # update role if provided and user is allowed to
      if params[:role] && current_user_may_edit(event)
        participation.role = params[:role]
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

end
# TODO Tests

class String
    def to_b()
        self.downcase == "true"
    end
end
