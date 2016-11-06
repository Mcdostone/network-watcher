require './counter'

network = '192.168.1.*'
counter = Counter.new(network)
counter.scan

counter.devices.each do |device|
	puts device
end