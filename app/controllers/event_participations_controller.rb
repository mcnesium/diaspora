class EventParticipationsController < ApplicationController
  before_action :authenticate_user!, :only => [:create]
  skip_before_filter :verify_authenticity_token

  def index
    # return all known event participations
    render :json => EventParticipation.all, content_type: "application/json"
  end

  def show
    # return given participation
    render :json => EventParticipation.find_by_event(params[:id]),
      content_type: "application/json"
  end

  def create
    # if not exists create otherwise update person-event-relation

    # get participation relation
    event = Event.find_by_guid(params[:event])
    person = Person.find_by_guid(params[:person])
    participation = EventParticipation.find_by_event_and_person(event,person)
    
    if participation == nil
      # no existing event-person-relation yet

      if person == current_user.person
        # attend to event, if this is me
        attending = params[:attending]
        invited_by = nil
      else
        # otherwise invite that person
        invited_by = current_user.person
        attending = false
      end

      # create participation with given properties
      participation = EventParticipation.create(
        person: person,
        event: event,
        invited_by: invited_by,
        attending: attending
      )
      # TODO andere einladen nur wenn man selbst participated?
      # TODO only if not exists yet

    else
      # event-person-relation already exists, one can only change own attendance
      if person == current_user.person && params[:attending] != nil
        # set given attendance update
        participation.attending = params[:attending]
        participation.save
      end

    end

    # if person.owner? && params[:role] != nil
    #   participation.role = params[:role]
    #   participation.save
    # end

    render :json => { result: participation }, content_type: "application/json"

  end

end
# TODO Tests
