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
    render :json => Event.find(params[:id])
        .to_json( :include => [
            :event_attendances,
            :event_invitations
        ]),
        content_type: "application/json"
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

    # create new event with given params
    else

      event = Event.create(
          author: current_user.person,
          title: params[:title],
          # start: params[:start],
      )

      Postzord::Dispatcher.defer_build_and_post(current_user, event)
      render :json => event.to_json, content_type: "application/json"
    end
  end

  def update

    event = Event.find(params[:id])
    editor = EventEditor.find_by( event: event, editor: current_user.person )

    # check if current user is editor or author of the event
    if (not editor) && (not event.author === current_user.person)
      render :json => { "error": "not allowed" }, status: 401, content_type: "application/json"
      return
    else
      # change local event
      event.title = params[:title] || event.title
      event.save

      # create an event update entity to federate
      @event_update = EventUpdate.new(
        event: event.guid,
        title: params[:title],
        diaspora_handle: current_user.diaspora_handle
      )
      Postzord::Dispatcher.build(current_user, @event_update).post

      # return updated event
      render :json => event, content_type: "application/json"
    end

  end

  respond_to :html

  def portal
    respond_to do |format|

      format.html { render 'index' }

    end
  end

end
