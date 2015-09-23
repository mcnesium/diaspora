class EventParticipationsController < ApplicationController

  respond_to :html, :json

  def index
    respond_with do |format|
      format.html { render :json => EventParticipation.all }
      format.json { render :json => EventParticipation.all }
    end
  end

  def show
    respond_with do |format|
      format.html { render :json => EventParticipation.find(params[:id]) }
      format.json { render :json => EventParticipation.find(params[:id]) }
    end
  end

end
