require './counter'
require 'pi_piper'
include PiPiper

network = '192.168.1.*'
counter = Counter.new(network)
devices = counter.scan

devices.each do |device|
	puts device
end

# To binary
puts counter.devices.length.to_s(2)