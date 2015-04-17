class RectanglePipe < Pipe
	
	def initialize(args={})
		@size = args[:size] || [3,5]
		args[:diameter] = @size[1]
		super(args)
	end
	
	def shape
		return square(@size).center_xy
	end	

	# We need to define this, so bents will be rotated by 90° while straight lines will not.
	def apply_rotation(obj)
		return obj.rotate(z:90)
	end


end
