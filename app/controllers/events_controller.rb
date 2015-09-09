class EventsController < ApplicationController

    respond_to :html, :mobile, :json, :xml

    def show
        @event = Event.find(params[:id])
    end
end
