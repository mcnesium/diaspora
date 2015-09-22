class EventsController < ApplicationController
  
  respond_to :html, :json

  def index
    respond_with do |format|
      format.html { render :json => Event.all }
      format.json { render :json => Event.all }
    end
  end

  def show
    respond_with do |format|
      format.html { render :json => Event.find(params[:id]) }
      format.json { render :json => Event.find(params[:id]) }
    end
  end

end
