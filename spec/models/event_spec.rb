require 'spec_helper'

describe Event, :type => :model do

  before do
    @event = Event.new( title: "Test Event", author: alice.person )
  end

  describe 'validation' do

    it 'should create an event' do
    	expect(@event).to be_valid
    end

  end
end
