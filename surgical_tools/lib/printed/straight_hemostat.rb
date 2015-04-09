class StraightHemostat < CrystalScad::Printed
	def initialize(args={})
		@holding_pins_width = 4
		@holding_pins_length = 10
		@holding_pins_height = 2.4

		@arm_thickness = 5
		@arm_length = 40 # TODO: measure on the original
		@height = 5	
	
	end
	
	def part(show)
		
		# defining the lower part as the one where the hinge has a male part
		lower = Grip.new(height:@height).part(show)
		
		#	the upper part has a lot of similarities with the lower part
		# So, we're doing exactly the same for pretty much everything except the hinge(?), then
		# mirror it in in y direction, then add the hinge.
		upper += Grip.new(height:@height).part(show)
		
		# TODO: The locking mechanism is to be implemented 
		# I'm adding a dummy cube right now in order to test out the hinge mechanism first.
		lower += cube([@holding_pins_width,@holding_pins_length,@holding_pins_height]).translate(x:-@holding_pins_width)
		upper += cube([@holding_pins_width,@holding_pins_length,@holding_pins_height]).translate(x:-@holding_pins_width,z:@height-@holding_pins_height)
		

	#	lower += cube([@arm_length,@arm_thickness,@height]).translate(y:-@arm_thickness)

		pipe = SquarePipe.new(size:@arm_thickness)
		pipe.line(@arm_length)		
		pipe.cw(20,28)
		pipe.ccw(20,28)
		
		lower += pipe.pipe.translate(y:-@arm_thickness/2.0,z:@arm_thickness/2.0)
		# note that ruby does alter the value in pipe.pipe with the upper command, so no need to do it again
		upper += pipe.pipe
		
		lower.translate(x:-pipe.sum_x)
		upper.translate(x:-pipe.sum_x)

		res	= lower.translate(y:-@holding_pins_length/2.0).color("Aquamarine") 
		res += upper.translate(y:-@holding_pins_length/2.0).mirror(y:1).color("DarkTurquoise") 
		res		
	end
end
