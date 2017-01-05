require './proxy_network_scanner'
require './network_scanner'
require './gpio_displayer'
require 'pi_piper'


network = '10.10.108.128/26'
#displayer = GpioDisplayer.new
scanner = NetworkScanner.new(network)
devices = scanner.scan

devices.each do |device|
	puts device
end

puts scanner.nb_devices
displayer.show(devices.empty ? scanner.nb_devices : devices.length)