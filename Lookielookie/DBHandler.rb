# encoding: utf-8
require 'pg'
class DBHandler

	def initialize(host,dbname,user,password)
	@conn = PG::Connection.open(:host => host ,:dbname => dbname, :user => user, :password => password)
	@conn.prepare('selectDeviceName', "SELECT * FROM select_device_by_name($1);")
	@conn.prepare('selectDeviceAddr', "SELECT * FROM select_device_by_adress($1);")
	@conn.prepare('selectAll', "SELECT * FROM select_all_devices();")
	@conn.prepare('listAll', "SELECT * FROM select_devices_name_and_addr_only();")
	@conn.prepare('createDevice', "SELECT * FROM make_new_device($1,$2);")
	@conn.prepare('deleteDevice', "SELECT * FROM delete_device($1);")
	@conn.prepare('changeName', "SELECT * FROM change_name($1,$2);")
	@conn.prepare('updateLocation', "SELECT * FROM update_location($1,$2);")
	@conn.prepare('updateLastseen', "SELECT * FROM update_lastseen($1);")
	end

	def selectDeviceByName(name)
		res = [] 
		@conn.exec_prepared('selectDeviceName', [name]) do |result|
			result.each do |row|
				res << row
			end
		end
		return res
	end

	def selectDeviceByAddr(addr)
		res = [] 
		@conn.exec_prepared('selectDeviceAddr', [addr]) do |result|
			result.each do |row|
				res << row
			end
		end
		return res
	end

	def selectAllDevices()
		res = []
		@conn.exec_prepared('selectAll') do |result|
			result.each do |row|
				res << row
			end
		end
		return res
	end 

	def listAllDevices()
		res = []
		@conn.exec_prepared('listAll') do |result|
			result.each do |row|
				res << row
			end
		end
		return res
	end

	def createNewDevice(addr,name)
		res = []
		begin
			@conn.exec_prepared('createDevice', [addr,name]) do |result|
				result.each do |row|
					res << row
				end
			end
			return true
		rescue PG::UniqueViolation => error
			puts "Device already exists"
			return false 
		rescue PG::NumericValueOutOfRange => error
			puts "Invalid input"
			return false
		end   
	end 

	def deleteDeviceFromDatabase(addr)
		res = []
		@conn.exec_prepared('deleteDevice', [addr]) do |result|
			result.each do |row|
				res << row
			end
		end
		return true
	end

	def changeDeviceName(addr,name)
		res = []
		begin
			@conn.exec_prepared('changeName', [addr,name]) do |result|
				result.each do |row|
					res << row
				end
			end
			return true
		rescue PG::UniqueViolation => error
			puts "Device already exists"
			return false
		end
	end

	def updateDeviceLocation(addr,location)
		res = []
		begin
			@conn.exec_prepared('updateLocation', [addr,location]) do |result|
				result.each do |row|
					res << row
				end
			end
			return true
		rescue PG::InvalidTextRepresentation => error
			puts "Invalid input HER"
			puts error
			return false
		end
	end

	def updateDeviceLastseen(addr)
		res = []
		@conn.exec_prepared('updateLastseen', [addr]) do |result|
			result.each do |row|
				res << row
			end
		end
		return true
	end
end



#puts selectAllDevices()
#puts createNewDevice("66:66:66:66:66:66","SatanSelv")
#puts selectDeviceByName("SatanSelv")
#myDBHandler = DBHandler.new('192.168.1.150','ItemDB','lookielookie','look')
#puts myDBHandler.selectDeviceByAddr("67:66:66:76:66:66").length
#puts changeDeviceName("66:66:66:66:66:66","SATAN")
#puts updateDeviceLocation("66:66:66:66:66:66","666,666")
#puts updateDeviceLastseen("66:66:66:66:66:66")

# :host => '192.168.1.150' ,:dbname => 'ItemDB', :user => 'lookielookie', :password => 'look' 