# encoding: utf-8
require_relative "BTHandler.rb"
require_relative "DBHandler.rb"
require_relative "LocationFinder.rb" 

@myBTHandler = BTHandler.new("hci0")
@myDBHandler = DBHandler.new('192.168.1.150','ItemDB','lookielookie','look')
@myLocationFinder = LocationFinder.new()

def listDeviceMenu()
	devices = @myDBHandler.listAllDevices
	input = ""
	devices.each.with_index(1) do |item,i|
		puts %{#{i}. #{item["BluetoothAddr"]} #{item["DeviceName"]}}
	end  
	input = Integer(gets.chomp)-1
	device = [devices[input]["BluetoothAddr"],devices[input]["DeviceName"]]
	puts %{You have selected the device #{device[1]} with the address #{device[0]}}
	puts "
	What would you like to do?
	1. Play a single sound from device
	2. Play continuous sound
	3. Rename device
	4. Get data on device from database
	5. Delete device from database
	6. Return to main menu"

	case Integer(gets.chomp)
	when 1
		@myBTHandler.commandPlaySound(device[0])
	when 2
		begin
			puts "press ^c to stop."
			loop do 
				@myBTHandler.commandPlaySound(device[0])
				sleep(2)
			end
		rescue Interrupt => e
			
		end

	when 3
		puts "Please select a new name for the device"
		name = gets.chomp
		@myDBHandler.changeDeviceName(device[0],name)
		@myBTHandler.commandGiveName(name,device[0]) 
		puts %{The device have been renamed to #{name}}
	when 4
		deviceinfo = @myDBHandler.selectDeviceByAddr(device[0])
		deviceinfo.each do |item|
			puts %{
			Bluetooth Address: 	#{item["BluetoothAddr"]}
			Device name: 		#{item["DeviceName"]}
			Signal Strength:    #{item["SignalStrength"]}
			Location: 			#{item["Location"]}
			LastSeen: 			#{item["Lastseen"]}
			Time added: 		#{item["TimeAdded"]}}
		end
	when 5
		puts "
		Are you sure you want to delete the device: #{device[1]}?
		[Y/N]"

		case gets.upcase.chomp
		when "Y"
		@myDBHandler.deleteDeviceFromDatabase(device[0])
		puts "Device deleted from database"
		when "N"
		puts "Action aborted"
		end  
	when 6
		puts "Returning to main menu"
	end
end

def scannedDeviceMenu() 
	device = ""
	scanresults = @myBTHandler.scanBLE(3)
		loop do
			device = @myBTHandler.scanMenu(scanresults)
			break if @myDBHandler.selectDeviceByAddr(device[0]).length < 1
			puts "This device already exist in the database, please choose another device"
		end
	puts %{
	The device will now be added to the database.
	Please select a name for the device: #{device[0]}}
	name = gets.chomp
	@myBTHandler.commandGiveName(name,device[0])
	puts "Inserting device with address #{device[0]} and name #{name} into database"
	@myDBHandler.createNewDevice(device[0],name)
	location = @myLocationFinder.getGPS()
	@myDBHandler.updateDeviceLocation(device[0],"#{location[0]},#{location[1]}")
end

def mainMenu() 
	puts "
	What would you like to do?
	1: Scan for available BLE devices
	2: Select BLE device from list of added devices"

	case Integer(gets.chomp)
	when 1
		scannedDeviceMenu() 	
	when 2
		listDeviceMenu() 
	end
end

bgScan = Thread.new {
	bgScanner = @myBTHandler.bgScan
	begin
		while line = bgScanner.gets do
			if line =~ /.+CHG.+ Device (.+) RSSI: (-\d\d)/
				if (@myDBHandler.selectDeviceByAddr($1).length > 0)
					puts "bgScanner found: #{$1}, #{$2}"
					location = @myLocationFinder.getGPS
					@myDBHandler.updateDeviceLocation($1, "#{location[0]},#{location[1]}")
					@myDBHandler.updateDeviceLastseen($1)
				end
			end
			
		end	
	rescue Exception => e
		puts e
		puts "OMG WE CRASHED ;("
		retry	
	end



}


loop do
	mainMenu()
end 

=begin
scanting = myBTHandler.scanBLE(3)
device = ""
loop do  
	device = myBTHandler.scanMenu(scanting)
	break if myDBHandler.selectDeviceByAddr(device[0]).length < 1
	puts "This device already exist, please choose another device"
end
puts %{Please select af name for the device: #{device[0]}}
name = gets.chomp
myDBHandler.createNewDevice(device[0],name)
myBTHandler.commandGiveName(name,device[0])
sleep(2)
myBTHandler.commandPlaySound(device[0])
location = myLocationFinder.getLocation()
myDBHandler.updateDeviceLocation(device[0],"#{location[0]},#{location[1]}")
=end


	#while true
		#puts "Begin reading"
		#puts myBTDevice.readText("CA:12:82:49:54:EB")
		#puts myBTDevice.readHandle("0x0011","0100","CA:12:82:49:54:EB")
	#end
	#writeText("0x000e",ASCIItoHex("Abe"),"CA:12:82:49:54:EB") 
	#readText("0x0011", "0100")
	#scanBLE(3)