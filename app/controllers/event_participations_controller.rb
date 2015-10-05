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

    # check if this is about me or another person
    if params[:person]
        person = Person.find(params[:person])
    else
        person = current_user.person
    end

    # find an already existing participation
    participation = EventParticipation.find_by(event:event,person:person)
    
    # existing participation
    if participation

      # update own attendance
      if params[:attending] && person == current_user.person
        participation.attending = params[:attending].to_b
        participation.save
      end

      # update role
      if params[:role] && participation.privileged?
        participation.role = params[:role].to_i
        participation.save
      end

    # new participation
    else

      # attend to event, if this is me
      if person == current_user.person
        participation = EventParticipation.create(
          person: person,
          event: event,
          attending: 1
        )
      # otherwise invite that person
      else
        participation = EventParticipation.create(
          person: person,
          event: event,
          invited_by: current_user.id,
        )
      end

    end

    render :json => participation, content_type: "application/json"

  end

end
# TODO Tests

class String
    def to_b()
        self.downcase == "true"
    end
end