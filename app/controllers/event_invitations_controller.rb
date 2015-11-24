class EventInvitationsController < ApplicationController
  before_action :authenticate_user!
  skip_before_filter :verify_authenticity_token

  def create
    # check for a given event to invite to
    if not params[:event]
      render :json => { "error": "'event' required" }, status: 422, content_type: "application/json"
      return
    # check for a given invitee to invite
    elsif not params[:invitee]
      render :json => { "error": "'invitee' required" }, status: 422, content_type: "application/json"
      return
    else
      event = Event.find(params[:event])
      invitee = Person.find(params[:invitee])

      # find an already existing invitation
      if EventInvitation.find_by( event: event, invitee: invitee )
        render :json => { "error": "invitation exists" }, status: 409, content_type: "application/json"
        return

      # create a new invitation
      else
        invitation = EventInvitation.create( event: event, invitee: invitee, invitor: current_user.person )

        Postzord::Dispatcher.defer_build_and_post(current_user, invitation)
        render :json => invitation, content_type: "application/json"
      end
    end
  end

end
