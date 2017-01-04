require 'open3'
require "ipaddress"
require 'socket'
require './device'

class NetworkScanner

	CMD_NMAP = "sudo nmap -sP -PR"
	CMD_ROUTER = "route -n | awk '$2 ~/[1-9]+/ {print $2;}'"
	PREFIX_LINE_ADDR = "Nmap scan report for"
	INDEX_NAME = 4

	attr_reader :devices, :router

	def initialize(network)
		@network = network
		@router = nil
		@addr_router = `#{CMD_ROUTER}`.strip 
		@devices = Array.new
	end

	def scan
		@devices = Array.new
		puts "scanning #{@network}"
		Open3.popen3(nmap_command) do |stdin, stdout, stderr, wait_thr|
			while line = stdout.gets
				addr = get_addr(line)
				if is_device(addr) && !is_host(addr) && !is_router(addr)
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

	def devices
		@devices
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

	def is_device(addr)
		IPAddress.valid?(addr)
	end

	def is_router(addr)
		addr == @addr_router
	end

	def is_host(addr)
		host = Socket.ip_address_list.detect{|intf| intf.ipv4_private?}.ip_address
		host == addr
	end
end