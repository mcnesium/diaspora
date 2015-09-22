class EventsController < ApplicationController

    # TODO def show, json, show all
    #

  respond_to :html,
             :json


  def index
    @events = Event.all

    respond_with do |format|
      format.html { render :json => Event.all }
      format.json { render :json => Event.all }
    end
  end

  def show
    @event = Event.find(params[:id])
  end

end
