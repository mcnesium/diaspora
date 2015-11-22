class EventUpdatesController
  def new(*args)
    byebug
    EventUpdate.new(
      *args
    )
  end
end
