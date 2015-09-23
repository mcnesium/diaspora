class EventInvitationsController < ApplicationController

  respond_to :html, :json

  def index
    respond_with do |format|
      format.html { render :json => EventInvitation.all }
      format.json { render :json => EventInvitation.all }
    end
  end

  def show
    respond_with do |format|
      format.html { render :json => EventInvitation.find(params[:id]) }
      format.json { render :json => EventInvitation.find(params[:id]) }
    end
  end

end
