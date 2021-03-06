require './network_scanner'


class ProxyNetworkScanner

	def initialize(network, pin_debug = 26)
		@pin_debug = pin_debug
		@scanner = NetworkScanner.new(network)
		@pin = PiPiper::Pin.new(:pin => @pin_debug, :direction => :out) 
	end

	def scan
		@pin.on
		@scanner.scan
		@pin.off
		@scanner.devices
	end

	def nb_devices
		@scanner.nb_devices
	end
end
