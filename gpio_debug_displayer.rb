require 'pi_piper'


class GpioDebugDisplayer

	DELAY = 2

	def initialize(pin_debug = 26)
		@pin_debug = pin_debug
	end

	def show
		Thread.new do
   			pin = PiPiper::Pin.new(:pin => @pin_debug, :direction => :out) 
			pin.on
			sleep 2
			pin.off
		end
	end

end