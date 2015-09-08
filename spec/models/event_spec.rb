require 'spec_helper'

describe Event, :type => :model do

    describe 'validation' do
        describe 'of object' do
            it 'is a valid object' do
                ev = Event.new(name: "Final Event", location: "The World", datetime: "2038-01-19 03:14:06")
                expect(ev.valid?).to be true
            end
        end
    end

end
