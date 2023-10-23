class Location < ApplicationRecord
	has_many :air_pollutions, dependent: :destroy
	validates_presence_of :lat, :lon, :name, :country
end
