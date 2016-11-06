require 'open3'
require "ipaddress"
require './device'

class Counter

	CMD_NMAP = "sudo nmap -sP -PR"
	CMD_ROUTER = "route -n | awk '$2 ~/[1-9]+/ {print $2;}'"
	PREFIX_LINE_ADDR = "Nmap scan report for"
	INDEX_NAME = 4

	attr_reader :devices, :router

	def initialize(network)
		@network = network
		@router = nil
		@devices = Array.new
	end

	def is_device(addr)
		IPAddress.valid?(addr) && !is_router(addr)
	end

	def is_router(addr)
		addr == `#{CMD_ROUTER}`.strip
	end

	def scan
		@devices = Array.new
		puts "scanning #{@network}"
		Open3.popen3(nmap_command) do |stdin, stdout, stderr, wait_thr|
			while line = stdout.gets
				#puts "#{line}"
				addr = get_addr(line)
				if is_device addr
					@devices.push(Device.new(addr, get_name(line)))
				elsif is_router(line)
					@router = Device.new(addr, get_name(line))
				end
			end
		end

		@devices
	end

	def count
		@devices.length
	end

	private
	def nmap_command()
		"#{CMD_NMAP} #{@network}"
	end

	def get_addr(line)
		if(line.start_with?(PREFIX_LINE_ADDR))
			line.scan(/\(([^\)]+)\)/).last.first
		else
			nil
		end
	end

	def get_name(line)
		if(line.start_with?(PREFIX_LINE_ADDR))
			line.split(' ')[INDEX_NAME]
		else
			nil
		end
	end
end