require './proxy_network_scanner'
require './network_scanner'
require './gpio_displayer'
require 'pi_piper'
require 'rufus-scheduler'


scheduler = Rufus::Scheduler.new
network = '192.168.1.*' 
scanner = NetworkScanner.new(network)

scheduler.in '2m' do
	devices = scanner.scan
	devices.each do |device|
		puts device
		displayer.show(devices.empty ? scanner.nb_devices : devices.length)
	end
end