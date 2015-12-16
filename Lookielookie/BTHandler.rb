# encoding: utf-8
class BTHandler
	
	def initialize(btDongle)
		
		#{}`sudo hciconfig #{btDongle} down`
		#sleep(1)
		#{}`sudo hciconfig #{btDongle} up`
		#sleep(1)
		output = ""


		# Length 0 means it went without error
		if output.length == 0
		puts "Device ready"

		else
			puts "Error: "
			puts output

		end

	end 

	def scanBLE(scanTime)
		blelist = []
		t = Time.now
		application = "sudo bluetoothctl"

		IO.popen(application, "r+") do |output|
			#output.puts "scan on"
			while line = output.gets.chomp do
				blelist << line

				if Time.now - t > scanTime
					#output.puts "scan off"
					break
				end
				
			end
		end

		results = []

		blelist.each do |dev|
			begin
				if dev =~ /.+NEW.+ Device ([\d\S][\d\S]:[\d\S][\d\S]:[\d\S][\d\S]:[\d\S][\d\S]:[\d\S][\d\S]:[\d\S][\d\S])\s(.+)/
					results << "#{$1} #{$2}"
				end
			rescue ArgumentError => e
				puts e.backtrace
				puts "The following string was strange:"
				puts dev
			end

		end

		return results.uniq

	end

	def bgScan()

		application = "sudo bluetoothctl"
		bgScanner = IO.popen(application, "r+")
		bgScanner.puts "scan on"

		return bgScanner
		
	end

	def splitScanresult(scanResult)

		return scanResult.split(' ')

	end 

	def getBLEPrimary(mac)
		
		output = `sudo gatttool -b #{mac} -t random --primary`

		puts output

	end

	def hexToASCII(inputString)

		# remove spaces
		inputString = inputString.gsub( / /, "" )

		output = ""
		

		# Pair two characters up and parse them as a character from HEX value 
		inputString.gsub(/../) {
			|pair|

			output += pair.hex.chr
		}


		return output
	end

	def ASCIItoHex(inputString)
		# inputString bliver sat i et Array, og vi tager så værdien fra den første plads (0)
		return inputString.unpack('H*')[0]
	end  	

	def readHandle(handle, value, device)
		
		application = %{sudo gatttool -t random -b #{device} --char-write-req --handle #{handle} --value #{value} --listen}
		recieved = ""

		IO.popen(application) do |output|
			while line = output.gets do
				if (line =~ /^.+value: (.+)$/)
					if $1.include? "0a"
						return $1
					end
				end
			end
		end
	end

	def readText(device)

		recieved = readHandle("0x0011","0100",device)
		return hexToASCII(recieved)
	end

	def writeHandle(handle, value, device)

		application = `sudo gatttool -t random -b #{device} --char-write --handle #{handle} --value #{value}`

		puts application
	end

	def writeText(value, device)

		writeHandle("0x000e",ASCIItoHex(value),device)		
	end 

	def commandGiveName(name, device)
			writeText("setName",device)
			writeText(name,device)
	end

	def commandPlaySound(device)
			writeText("makeSound",device)
	end

	def scanMenu(scanResults)

		scanResults.each.with_index(1) do |result,i|
			puts %{#{i}. #{result}}
		end
		begin
			puts "Please select device" 
			input = Integer(gets.chomp)-1
		rescue ArgumentError => error
			puts "Not a valid input"
			retry
		end 		
		selectedDevice = splitScanresult(scanResults[input])
		puts %{You have seleceted the device: #{selectedDevice[1]} with the address: #{selectedDevice[0]}}

		return splitScanresult(scanResults[input])  
	end


	#readText("0x0011", "0100")
	#scanBLE(3)	
end