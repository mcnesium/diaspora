class EventParticipationsController < ApplicationController
  before_action :authenticate_user!, :only => [:create]
  skip_before_filter :verify_authenticity_token

  def show
    # return given participation
    render :json => EventParticipation.find_by_event(params[:id]),
      content_type: "application/json"
  end

  def create
    begin
      # try to create new participation entry
      event = Event.find_by_guid(params[:event])
      person = Person.find_by_guid(params[:person]) || current_user.person
byebug
      if person == current_user.person
        # attend to event, if this is me
        participation = EventParticipation.create(
          person: person,
          event: event,
          attending: 1
        )
      else
        # otherwise invite that person
        participation = EventParticipation.create(
          person: person,
          event: event,
          invited_by: current_user.person,
        )
      end

    rescue ActiveRecord::RecordNotUnique
      # participation recort already exists, update it
      participation = EventParticipation.find_by_event_and_person(event,person)
      
      # update own attendance
      if person == current_user.person && !params[:attending].nil?
        participation.attending = params[:attending].to_b
        participation.save
      end

    end
    
    render :json => { result: participation }

    # get participation relation
    # if participation.nil? 
    #   # no existing event-person-relation yet

    #   if person == current_user.person
    #     # attend to event, if this is me
    #     participation = EventParticipation.create(
    #       person: person,
    #       event: event,
    #       attending: 1
    #     )
    #   else
    #     # otherwise invite that person
    #     participation = EventParticipation.create(
    #       person: person,
    #       event: event,
    #       invited_by: current_user.person,
    #     )
    #   end

    #   render :json => { result: participation }, content_type: "application/json"

    #   # # TODO andere einladen nur wenn man selbst participated?
    #   # # TODO only if not exists yet

    # else
    #   render :json => { error: "exists", participation: participation },
    #     content_type: "application/json"

    #   # event-person-relation already exists, one can only change own attendance
    #   # if person == current_user.person && params[:attending] != nil
    #   #   # set given attendance update
    #   #   participation.attending = params[:attending]
    #   #   participation.save
    #   # end

    # end

    # if person.owner? && params[:role] != nil
    #   participation.role = params[:role]
    #   participation.save
    # end

    # render :json => { result: participation }, content_type: "application/json"

  end

end
# TODO Tests

class String
    def to_b()
        self.downcase == "true"
    end
end