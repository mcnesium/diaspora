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

end
