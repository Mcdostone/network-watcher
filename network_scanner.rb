require 'open3'
require "ipaddress"
require 'socket'
require './device'

class NetworkScanner

	CMD_NMAP = "sudo nmap -sP -PR"
	CMD_ROUTER = "route -n | awk '$2 ~/[1-9]+/ {print $2;}'"
	PREFIX_LINE_ADDR = "Nmap scan report for"
	PREFIX_END_NMAP = "Nmap done: "
	INDEX_NAME = 4

	attr_reader :devices, :router

	def initialize(network)
		@network = network
		@router = nil
		@addr_router = `#{CMD_ROUTER}`.split("\n")[0].strip
		@devices = Array.new
		@nb_devices_detected = 0
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
				elsif is_end_nmap(line)
					@nb_devices_detected = get_nb_ip_found_nmap(line)
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

	def nb_devices
		@nb_devices_detected
	end

	private
	def nmap_command()
		"#{CMD_NMAP} #{@network}"
	end

	def get_addr(line)
		line ||= "--"
		if(line.start_with?(PREFIX_LINE_ADDR))
			res = line.scan(/\(([^\)]+)\)/)
			#line.scan(/\(([^\)]+)\)/).last.first
			return res.last.first unless res.empty?
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

	def is_end_nmap(line)
		line.start_with?(PREFIX_END_NMAP)
	end

	def get_nb_ip_found_nmap(line)
		nb = line.scan(/([0-9]+) IP/).first.last
		#nb = line.scan(/([0-9]+) IP/)
		Integer(nb) if nb
	end
end