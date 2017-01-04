require 'pi_piper'
include PiPiper

class GpioCounter

	# little indians are little pins
	def initialize(max = 32)
		@max||= max
		@available_pins= [4, 5, 6, 12, 13, 16, 17, 18, 22, 23, 24, 25, 27]
	end

	def show(value)
		begin
			binary_value = value.to_s(2)
			puts "#{binary_value}\n"
			index_pin = 0
			if binary_value.length < Math.log(@max)/Math.log(2)
				binary_value.each_char do |digit|
					pin = PiPiper::Pin.new(:pin => @available_pins[index_pin], :direction => :out)
					pin.on
					index_pin+= 1
				end
			end

			rescue Exception => erro
				puts "#{erro}\n"
		end
	end
end