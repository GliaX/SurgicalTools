class StraightHemostat < CrystalScad::Printed
	def initialize(args={})
		@holding_pins_width = 7
		@holding_pins_length = 10
		# Valleys of the holding pins			
		@holding_pins_base_height = 2.2
		# Highest part of the holding pins
		@holding_pins_height = 3.2

		# Number of pins 
		@holding_pin_count = 4	
		# Length of each pin		 
		@holding_pin_length = 1.5
		# Spacing between each pin (must be greater than pin length)
		@holding_pin_spacing = 1.5

		@arm_thickness = 5

		# Bending radius of the arm 	
		@arm_radius=155
		@arm_angle=15
		# Additional length of straight line towards the grip
		@arm_additional_length = 30


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

		# Hinge part
		lower += cylinder(d:@hinge_area_diameter,h:@hinge_area_height).
		upper += cylinder(d:@hinge_area_diameter,h:@hinge_area_height).translate(z:@height-@hinge_area_height)

		# Toolhead part		
		lower += toolhead().mirror(y:1)
		upper += toolhead(raise_z:@height-@hinge_area_height,offset:0.5).mirror(y:1)


		# This defines the arm shape
		pipe = SquarePipe.new(size:@arm_thickness)
		# And an additional line, if configured 
		pipe.line(@arm_additional_length)	if @arm_additional_length > 0
		# The bent towards the hinge
		pipe.ccw(@arm_radius,@arm_angle)	
		
		lower += pipe.pipe.mirror(x:1).translate(y:3,z:@arm_thickness/2.0)
		# note that ruby does alter the value in pipe.pipe with the upper command, so no need to do it again
		upper += pipe.pipe		


		# Hinge inner cut
		lower -= cylinder(d:@hinge_hole_diameter,h:@height+0.2).translate(z:-0.1)
		upper -= cylinder(d:@hinge_hole_diameter,h:@height+0.2).translate(z:-0.1)
	

		# Cutting out the excess walls of the hinge, so it can open freely, to a degree.
		lower -= cylinder(d:@hinge_area_diameter+@hinge_clearance,h:@hinge_area_height+0.1).translate(z:@hinge_area_height)
		upper -= cylinder(d:@hinge_area_diameter+@hinge_clearance,h:@hinge_area_height+0.1)#.translate(z:@hinge_area_height)


		# in order to attach the grip properly, temporarily  move the arm
		lower.translate(x:pipe.x+@arm_additional_length)
		upper.translate(x:pipe.x+@arm_additional_length)

		# I need to calculate one side of the y value for putting the grip in the right place
		y = ((pipe.x+@arm_additional_length) / Math::sin(radians(90-@arm_angle))) * Math::sin(radians(@arm_angle)) 

		lower += Grip.new(height:@height).part(show).mirror(y:1).rotate(z:-@arm_angle).translate(y:y/2.0)
		upper += Grip.new(height:@height).part(show).mirror(y:1).rotate(z:-@arm_angle).translate(y:y/2.0)
		
	
		# Locking pins, non-rotated
		lower += locking_pins.translate(x:-@holding_pins_width).mirror(y:1).translate(y:y/2.0)
		upper += locking_pins.mirror(z:1).translate(x:-@holding_pins_width,z:@height).mirror(y:1).translate(y:y/2.0)		


		# Moving it all back to hinge as center
		lower.translate(x:-pipe.x-@arm_additional_length)
		upper.translate(x:-pipe.x-@arm_additional_length)

			

		if show
			res	= lower.color("Aquamarine") 
			res += upper.mirror(y:1).color("DarkTurquoise").rotate(z:@opening_angle)
		else
			res	= lower
			res += upper.translate(y:@holding_pins_length*2).mirror(z:1).translate(y:15,z:@height)
		end
	
		res		
	end

	def locking_pins
		res = HoldingPins.new.output
	end


	def toolhead(args={})
		raise_z = args[:raise_z] || 0 # for hinge

		offset = args[:offset] || 0 # offset for better gripping

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

		# This is a tiny cylinder that is put there in order to improve the print.
		# In my testing, my printed put a tiny blob of excess material in there on direction change, stopping the device to close completely
		# that little cut should fix this.
		res -= cylinder(d:0.5,h:@hinge_area_height).translate(x:(@hinge_area_diameter+@hinge_clearance)/2.0).translate(z:@hinge_area_height-raise_z)

		# The teeth are currently quite unparametric. Let's try if it works.
		(@toolhead_length/1).round.times do |i|
			res -= cylinder(d:0.8,h:@height).translate(x:(@hinge_area_diameter+@hinge_clearance)/2.0+1.2+i+offset)
		end

		res

	end

end
