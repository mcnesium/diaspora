class EventParticipationsController < ApplicationController

  respond_to :all

  def index
    respond_with do |format|
      format.all { render :json => EventParticipation.all }
    end
  end

  def show
    respond_with do |format|
      format.all { render :json => EventParticipation.find_by_event(params[:id]) }
    end
  end

  def create
    respond_with do |format|
      format.all {
        EventParticipation.create(
          person: Person.find_by_guid(params[:person]),
          event: Event.find_by_guid(params[:event]),
          invited_by: Person.find_by_guid(params[:invited_by]),
          attending: params[:attending]
        )
        render :json => { result: "ok" }
      }
    end
  end

end
