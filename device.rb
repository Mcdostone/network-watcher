class Device

	attr_reader :addr, :name

	def initialize(addr, name)
		@addr = addr
		@name = name
	end

	def to_s
		"#{@name} => #{@addr}"
	end
end