class EventsController < ApplicationController
  before_action :authenticate_user!

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
        @event = Event.create( title: params[:title], start: params[:start] )
        # @ep = EventParticipation.create(
        #   person: current_user.guid,
        #   event: @event.guid,
        #   status: 2
        # )
        render :json => { result: "ok" }
      }
    end
  end

end
