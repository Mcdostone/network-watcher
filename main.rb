require './proxy_network_scanner'
require './network_scanner'
require './gpio_displayer'
require 'pi_piper'
require 'rufus-scheduler'
require 'optparse'

scheduler = Rufus::Scheduler.new
scanner = ProxyNetworkScanner.new(network)
displayer = GpioDisplayer.new(16)
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


if(options[:network])
	execute(options[:network], options[:delay])
end


def execute(network, delay)
	scheduler.every delay do
		puts "-- Scanning #{network} ..."
		devices = scanner.scan

		devices.each do |device|
			puts "-- Devices found : \n#{device}"
		end
		
		displayer.show(devices.empty? ? scanner.nb_devices : devices.length)
		puts "\n"
	end
	scheduler.join
end