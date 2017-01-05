require './proxy_network_scanner'
require './network_scanner'
require './gpio_displayer'
require 'pi_piper'
require 'rufus-scheduler'
require 'optparse'

def execute_main(network, delay)
	scanner = ProxyNetworkScanner.new(network)
	displayer = GpioDisplayer.new(16)
	scheduler = Rufus::Scheduler.new(:max_work_threads => 1)
	
	begin
		scheduler.every delay do
			puts "-- Scanning #{network} ..."
			devices = scanner.scan

			puts "-- Devices found:"
			devices.each do |device|
				puts "\t#{device}"
			end
			
			displayer.show(devices.empty? ? scanner.nb_devices : devices.length)
			puts "\n"
		end
	rescue Interrupt => i
		scheduler.join
	end

	scheduler.join	
end

# ------------------

options = {}
OptionParser.new do |parser|
	parser.banner = "USAGE: network_watcher --network 192.168.1.* [options]"

  	parser.on("-h", "--help", "Show this help message") do ||
    	puts parser
  	end
	parser.on("-d", "--delay DELAY", "Delay in seconds between each scan") do |v|
		options[:delay] = v
	end
	parser.on("-n", "--network addr", "range of address to scan ( 192.168.1.* by default") do |addr|
		options[:network] = addr
	end

	options[:delay]||= '20'
	options[:network]||= '192.168.1.*'

end.parse!

execute_main(options[:network], options[:delay])