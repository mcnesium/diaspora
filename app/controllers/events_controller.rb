class EventsController < ApplicationController
  before_action :authenticate_user!, :only => [:create, :update]
  skip_before_filter :verify_authenticity_token
  #
  # require 'date'
  #
  def index
    # return all known events
    render :json => Event.all, content_type: "application/json"
  end

  def show
    # return given event, include event-related participations
    render :json => Event.find(params[:id]).to_json,
                    content_type: "application/json"
      # .to_json( :include => :event_participations ),

  end

  def create

    # check if valid date or return error
    # begin
    #     start = Date.parse(params[:start])
    # rescue ArgumentError => e
    #   render :json => { "error": "Invalid date" },
    #           status: 400,
    #           content_type: "application/json"
    #   return
    # end

    # check if title or return error
    if not params[:title]
        render :json => { "error": "'title' required" },
                status: 422,
                content_type: "application/json"
      return
    end

    # create new event with given params
    event = Event.create(
        author: current_user.person,
        title: params[:title],
        # start: params[:start],
    )
    # create participation, set the current user to the event's owner
    # participation = EventParticipation.create(
    #    participant: current_user.person,
    #    event: event,
    #    role: EventParticipation.roles[:owner]
    # )
    # return created event
    # binding.pry

    Postzord::Dispatcher.defer_build_and_post(current_user, event)
    render :json => event.to_json, content_type: "application/json"
  end

  # def update
  #   # get given event, check if it actually exists
  #   event = Event.find(params[:id])
  #
  #   # get event-related event participation
  #   ep = EventParticipation.find_by(event: event, participant: current_user.person)
  #
  #   # return false and exit if current user is not related or not privileged
  #   if ep == nil || !ep.privileged?
  #     render :json => { "error": "You are not allowed to update this event" },
  #           status: 403,
  #           content_type: "application/json"
  #     return
  #   end
  #
  #   # else, if current user is allowed, edit the event details
  #   event.title = params[:title] || event.title
  #   event.start = params[:start] || event.start
  #   event.save
  #
  #   Postzord::Dispatcher.defer_build_and_post(current_user, event)
  #
  #   # return updated event
  #   render :json => event, content_type: "application/json"
  #
  # end

end
