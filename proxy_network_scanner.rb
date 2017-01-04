require './network_scanner'


class ProxyNetworkScanner

	def initialize(network, pin_debug = 26)
		@pin_debug = pin_debug
		@scanner = NetworkScanner.new(network)
	end

	def scan
		pin = PiPiper::Pin.new(:pin => @pin_debug, :direction => :out) 
		pin.on
		@scanner.scan
		pin.off

		@scanner.devices
	end
end
