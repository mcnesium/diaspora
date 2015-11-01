class EventRelationsController < ApplicationController
  before_action :authenticate_user!, :only => [:create]
  skip_before_filter :verify_authenticity_token

  def show
    # return given relation
    render :json => EventRelation.find_by_event_id(params[:id]),
      content_type: "application/json"
  end

  def create
    if params[:event]
      event = Event.find(params[:event])
    else
      render_error(400,"No event given")
      return
    end

    # check if this is about me or another target person
    if params[:target]
        target = Person.find(params[:target])
    else
        target = current_user.person
    end

    # find an already existing relation
    relation = EventRelation.find_by(event:event,target:target)

    # existing relation
    if relation

      # update own attendance if this is me
      if params[:attending] && target == current_user.person
        relation.attending = params[:attending].to_b
      # update role if provided and user is allowed to
    elsif params[:role]
        if current_user_is_owner(event)
          relation.role = params[:role]
        else
          render_error(403,"You are not allowed to edit this event")
          return
      end
      else
        render_error(400,"Nothing to update")
        return
      end
      # update the relation
      relation.save

    # new relation
    else

      relation = {
        "target" => target,
        "event" => event
      }
      # attend to event if this is me
      if target == current_user.person
        relation["attending"] = 1
      # or set the relation role if provided and user is allowed to
      elsif params[:role] && current_user_may_edit(event)
        relation["role"] = params[:role]
      # otherwise invite that person
      else
        relation["invitor"] = current_user.person
      end
      # create the relation
      EventRelation.create(relation)

    end

    Postzord::Dispatcher.defer_build_and_post(current_user, relation)
    render :json => relation, content_type: "application/json"

  end

  def current_user_may_edit(event)
    relation = EventRelation.find_by( event: event, target: current_user.person )
    if relation && relation.may_edit?
      return true
    else
      return false
    end
  end

  def current_user_is_owner(event)
    relation = EventRelation.find_by( event: event, target: current_user.person )
    if relation && relation.is_owner?
      return true
    else
      return false
    end
  end

  def render_error(status,string)
    render :json => { "error": string }, status: status, content_type: "application/json"
  end

end
# TODO Tests

class String
    def to_b()
        self.downcase == "true"
    end
end
