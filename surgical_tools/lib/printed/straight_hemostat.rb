class StraightHemostat < CrystalScad::Printed
	def initialize(args={})
		@holding_pins_width = 4
		@holding_pins_length = 11
		# Valleys of the holding pins			
		@holding_pins_base_height = 1.8
		# Highest part of the holding pins
		@holding_pins_height = 3.2

		# Number of pins (including the furthermost one)
		@holding_pin_count = 5	
		# Length of each pin		 
		@holding_pin_length = 1
		# Spacing between each pin (must be greater than pin length)
		@holding_pin_spacing = 1.3

		@arm_thickness = 5
		@arm_length = 40 # TODO: measure on the original
		@height = 5	
		@hinge_area_height = 2.5

		@hinge_area_diameter = 11.3
		@hinge_hole_diameter = 3.4
		@hinge_clearance = 1.5 # extra clearance for the hinge, higher values mean more possible rotation

		# TODO: The values here are guesstimated for a proof of concept model 
		@toolhead_witdh = 5	
		@toolhead_tip_witdh = 3
		@toolhead_length = 40
		
		# Angle of the two parts to each other, only for show
		@opening_angle = 0

	end
	
	def part(show)
		
		# defining the lower part as the one where the hinge has a male part
		lower = Grip.new(height:@height).part(show)
		
		#	the upper part has a lot of similarities with the lower part
		# So, we're doing exactly the same for pretty much everything except the hinge(?), then
		# mirror it in in y direction, then add the hinge.
		upper += Grip.new(height:@height).part(show)
		
		# Locking mechanism
		lower += locking_pins.translate(x:-@holding_pins_width)
		upper += locking_pins.mirror(z:1).translate(x:-@holding_pins_width,z:@height)			

		pipe = SquarePipe.new(size:@arm_thickness)
		pipe.line(@arm_length)		
		pipe.cw(r=21.5,angle=28)
		pipe.ccw(r,angle)
	
		lower += pipe.pipe.translate(y:-@arm_thickness/2.0,z:@arm_thickness/2.0)
		# note that ruby does alter the value in pipe.pipe with the upper command, so no need to do it again
		upper += pipe.pipe
		
		# Putting the now upcoming hinge in the center
		lower.translate(x:-pipe.sum_x,y:-@hinge_area_diameter/2.0)
		upper.translate(x:-pipe.sum_x,y:-@hinge_area_diameter/2.0)

		# Hinge part
		lower += cylinder(d:@hinge_area_diameter,h:@hinge_area_height)	
		upper += cylinder(d:@hinge_area_diameter,h:@hinge_area_height).translate(z:@height-@hinge_area_height)

		# Toolhead part		
		lower += toolhead()
		upper += toolhead(raise_z:@height-@hinge_area_height)

		# Hinge inner cut
		lower -= cylinder(d:@hinge_hole_diameter,h:@height+0.2).translate(z:-0.1)
		upper -= cylinder(d:@hinge_hole_diameter,h:@height+0.2).translate(z:-0.1)
	

		# Cutting out the excess walls of the hinge, so it can open freely, to a degree.
		lower -= cylinder(d:@hinge_area_diameter+@hinge_clearance,h:@hinge_area_height+0.1).translate(z:@hinge_area_height)
		upper -= cylinder(d:@hinge_area_diameter+@hinge_clearance,h:@hinge_area_height+0.1)#.translate(z:@hinge_area_height)


			

		if show
			res	= lower.color("Aquamarine") 
			res += upper.mirror(y:1).color("DarkTurquoise").rotate(z:-@opening_angle)
		else
			res	= lower
			res += upper.translate(y:@holding_pins_length*2).mirror(z:1).translate(y:15,z:@height)
		end
	
		res		
	end

	def locking_pins
		res = cube([@holding_pins_width,@holding_pins_length,@holding_pins_base_height])
		@holding_pin_count.times do |i|
			res += cube([@holding_pins_width,@holding_pin_length,@holding_pins_height]).translate(y:(@holding_pin_length+@holding_pin_spacing)*i)
		end	
		res
	end


	def toolhead(args={})
		raise_z = args[:raise_z] || 0

		# Hinge to toolhead connection
		res = hull(
					cylinder(d:@hinge_area_diameter,h:@hinge_area_height).translate(z:raise_z),
					cube([0.1,0.1,@hinge_area_height]).translate(z:raise_z),
					cube([0.1,0.1,@hinge_area_height]).translate(y:@toolhead_witdh,z:raise_z)
		)
	
		res += hull(
						cube([0.1,0.1,@height]),
						cube([0.1,0.1,@height]).translate(x:@toolhead_length),
						cube([0.1,0.1,@height]).translate(x:@toolhead_length,y:@toolhead_tip_witdh),
						cube([0.1,0.1,@height]).translate(y:@toolhead_witdh)
			)
		# TODO: The hemostat has slightly spiced teeth

	end

end
