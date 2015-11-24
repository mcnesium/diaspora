class EventEditorsController < ApplicationController
  before_action :authenticate_user!
  skip_before_filter :verify_authenticity_token

  def create
    # check for a given event
    if not params[:event]
      render :json => { "error": "'event' required" }, status: 422, content_type: "application/json"
      return
    # check for a given future editor
    elsif not params[:editor]
      render :json => { "error": "'editor' required" }, status: 422, content_type: "application/json"
      return
    else
      event = Event.find(params[:event])
      future_editor = Person.find(params[:editor])

      # check if current user is author of the event
      if not event.author == current_user.person
        render :json => { "error": "not allowed" }, status: 401, content_type: "application/json"
        return
      # check for an already existing editor
    elsif EventEditor.find_by( event: event, editor: future_editor )
        render :json => { "error": "editor exists" }, status: 409, content_type: "application/json"
        return

      # create a new editor
      else
        editor = EventEditor.create( event: event, editor: future_editor )

        Postzord::Dispatcher.defer_build_and_post(current_user, editor)
        render :json => editor, content_type: "application/json"
      end
    end
  end

end
