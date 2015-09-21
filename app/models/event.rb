class Event < ActiveRecord::Base
  include Diaspora::Federated::Base
  include Diaspora::Guid

  belongs_to :status_message

  #forward some requests to status message, because a poll is just attached to a status message and is not sharable itself
  delegate :author, :author_id, :diaspora_handle, :public?, :subscribers, to: :status_message

end
