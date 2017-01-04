require './counter'
require './gpio_counter'
require 'pi_piper'
include PiPiper

network = '192.168.1.*'
displayer = GpioCounter.new
counter = Counter.new(network)
devices = counter.scan

devices.each do |device|
	puts device
end

displayer.show(devices.length)