class SquarePipe < Pipe
	
	def initialize(args={})
		@size = args[:size] || 3
		args[:diameter] = @size
		super(args)
	end
	
	def shape
		return square([@size,@size]).center_xy
	end	

end
