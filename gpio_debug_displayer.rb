require 'pi_piper'


class GpioDebugDisplayer

	def initialize(pin_debug = 26)
		@pin_debug = pin_debug
	end

	def show
		Thread.new do
   			pin = PiPiper::Pin.new(:pin => @pin_debug, :direction => :out) 
			for i in 0..5
				pin.off
				sleep(1)
				pin.on
			end 
			pin.off
		end
	end

end