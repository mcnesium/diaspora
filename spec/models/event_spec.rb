require 'spec_helper'

describe Event, :type => :model do

  it 'is a valid object' do
    expect(event_1.valid?).to be true
    # TODO RAILS_ENV="test" bin/rake db:create db:schema:load fails
  end

end
