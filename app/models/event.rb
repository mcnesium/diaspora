class Event < ActiveRecord::Base
    validates :name, presence: true
    validates :datetime, presence: true
end
