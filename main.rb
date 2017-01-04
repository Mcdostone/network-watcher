require './network_scanner'
require './gpio_displayer'
require './gpio_debug_displayer'
require 'pi_piper'


network = '192.168.1.*'
displayer = GpioDisplayer.new
scanner = NetworkScanner.new(network)
debug = GpioDebugDisplayer.new
debug.show
devices = scanner.scan

devices.each do |device|
	puts device
end

displayer.show(devices.length)