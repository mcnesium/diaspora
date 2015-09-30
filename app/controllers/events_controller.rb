class EventsController < ApplicationController
  before_action :authenticate_user!
  skip_before_filter :verify_authenticity_token

  respond_to :all

  def index
    respond_with do |format|
      format.all { render :json => Event.all }
    end
  end

  def show
    respond_with do |format|
      format.all { render :json => Event.find_by_guid(params[:id]).to_json( :include => :event_participations ) }
    end
  end

  def create
    respond_with do |format|
      format.all {
        event = Event.create(
            title: params[:title],
            start: params[:start],
        )
        ep = EventParticipation.create(
           person: current_user.person,
           event: @event,
           status: EventParticipation.statuses[:owner]
        )
        render :json => { result: event }
      }
    end
  end

  def update

    ev = Event.find_by_guid(params[:id])
    ep = EventParticipation.find_by_event_and_person(ev, current_user.person)

    unless ev || ep || ep.privileged?
      format.all {
        render :json => { result: "false" }
      }
      return
    end
    # TOTO darf sachen ändern
    if params[:title]
      ev.title = params[:title] # oder oder gleich
    end
    # für die anderen sachen auch so
    ev.save
    
      render :json => { result: ev } 
    

  end


end
