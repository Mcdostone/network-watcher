require './proxy_network_scanner'
require './network_scanner'
require './gpio_displayer'
require 'pi_piper'
require 'rufus-scheduler'

scheduler = Rufus::Scheduler.new
network = '192.168.1.*' 
scanner = ProxyNetworkScanner.new(network)
displayer = GpioDisplayer.new(16)

scheduler.every '20' do
	puts "Scanning #{network} ...\n"
	devices = scanner.scan

	devices.each do |device|
		puts device
	end
	
	displayer.show(devices.empty? ? scanner.nb_devices : devices.length)
	puts "\n\n"
end


scheduler.join