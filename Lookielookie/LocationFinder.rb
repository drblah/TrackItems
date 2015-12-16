# encoding: utf-8
require "open-uri"
require "json"
require "gpsd_client"

class LocationFinder
	def getLocation()
		locationData = JSON.parse(open("http://ip-api.com/json").read)
			return locationData['lat'],locationData['lon']
	end

	def getGPS()
		gpsd = GpsdClient::Gpsd.new
		gpsd.start
		pos = gpsd.get_position
		return pos[:lat],pos[:lon]
	end
end 