require 'pi_piper'


class GpioDisplayer

	# little indians are little pins
	def initialize(max = 32)
		@max||= max
		@available_pins= [4, 5, 6, 12, 13, 16, 17, 18, 22, 23, 24, 25, 27]
		@used_pins = {}
	end

	def show(value)
		begin
			binary_value = value.to_s(2).reverse
			index_pin = 0
			@used_pins.each { |pin|  pin.off }
			if binary_value.length < Math.log(@max)/Math.log(2)
				binary_value.each_char do |digit|
					num_pin = @available_pins[index_pin]
					if @used_pins[num_pin].nil?
						@used_pins[num_pin] = PiPiper::Pin.new(:pin => @available_pins[index_pin], :direction => :out) 
					end
					@used_pins[num_pin].on if digit == "1"
					index_pin+= 1
				end
			end
			rescue Exception => erro
				puts "#{erro}\n"
		end
	end
end