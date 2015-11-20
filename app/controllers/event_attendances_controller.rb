class EventAttendancesController < ApplicationController
  before_action :authenticate_user!
  skip_before_filter :verify_authenticity_token

  def create
    # check for a given event to attend to
    if not params[:event]
      render :json => { "error": "'event' required" }, status: 422, content_type: "application/json"
      return
    else
      event = Event.find(params[:event])

      # find an already existing attendance
      if EventAttendance.find_by( event: event, attendee: current_user.person )
        render :json => { "error": "attendance exists" }, status: 409, content_type: "application/json"
        return

      # create a new attendance
      else
        attendance = EventAttendance.create( event: event, attendee: current_user.person )

        Postzord::Dispatcher.defer_build_and_post(current_user, attendance)
        render :json => attendance, content_type: "application/json"
      end
    end
  end

  def destroy
    # find the given attendance corresponding to the current user
    @attendance = EventAttendance.find_by_id_and_attendee_id!(params[:id], current_user.person.id)
    current_user.retract(@attendance)
    render :json => { "success": "attendance deleted" }, content_type: "application/json"
  end

end
