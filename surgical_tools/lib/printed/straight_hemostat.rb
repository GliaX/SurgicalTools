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
	
		# Rotation of the holding pins
		@holding_pin_rotation = 6

		# Height of the arms and the rest apart from the hinge
		@height = 7	
		# Thickness of the arms
		@arm_thickness = 10

		# Bending radius of the arm 	
		@arm_radius=155
		@arm_angle=20
		# Additional length of straight line towards the grip
		@arm_additional_length = 30

		# spacing between the arms
		@arm_spacing = 5.2

		@hinge_area_height = @height / 2.0

		@hinge_area_diameter = 20.5
		@hinge_hole_diameter = 3.4
		@hinge_clearance = 1.5 # extra clearance for the hinge, higher values mean more possible rotation

		# TODO: The values here are guesstimated for a proof of concept model 
		@toolhead_width = 5	
		@toolhead_tip_width = 3
		@toolhead_length = 40
		
		# Angle of the two parts to each other, only for show
		@opening_angle = 0

	end
	
	def view1
		@opening_angle = 15
	end

	def view2
		@opening_angle = -11.2
	end


	def part(show)

		# Hinge part
		lower += cylinder(d:@hinge_area_diameter,h:@hinge_area_height).
		upper += cylinder(d:@hinge_area_diameter,h:@hinge_area_height).translate(z:@height-@hinge_area_height)

		# Toolhead part		
		lower += toolhead(show:show).mirror(y:1)
		upper += toolhead(raise_z:@height-@hinge_area_height,offset:0.5,show:show).mirror(y:1)


		# This defines the arm shape
		pipe = RectanglePipe.new(size:[@height,@arm_thickness])

		# And an additional line, if configured 
		pipe.line(@arm_additional_length)	if @arm_additional_length > 0
		# The bent towards the hinge
		pipe.ccw(@arm_radius,@arm_angle)	
		
		lower += pipe.pipe.mirror(x:1).translate(y:@arm_spacing,z:@height/2.0)
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
		
	
		# Locking pins
		lower += locking_pins.translate(x:-@holding_pins_width).mirror(y:1).rotate(z:-@holding_pin_rotation).translate(y:y/2.0)
		upper += locking_pins.mirror(z:1).translate(x:-@holding_pins_width,z:@height).mirror(y:1).rotate(z:-@holding_pin_rotation).translate(y:y/2.0)		


		# Moving it all back to hinge as center
		lower.translate(x:-pipe.x-@arm_additional_length)
		upper.translate(x:-pipe.x-@arm_additional_length)

			

		if show
			res	= lower.color("Aquamarine") 
			res += upper.mirror(y:1).color("DarkTurquoise").rotate(z:@opening_angle)
		else
			res	= print_plate(lower,upper)
		end
	
		res		
	end

	def print_plate(lower,upper)
		res	= lower
		res += upper.translate(y:@holding_pins_length*2).mirror(z:1).translate(x:14,y:6,z:@height)
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
					cube([0.1,0.1,@hinge_area_height]).translate(y:@toolhead_width,z:raise_z)
		)
	
		res += hull(
						cube([0.1,0.1,@height]),
						cube([0.1,0.1,@height]).translate(x:@toolhead_length),
						cube([0.1,0.1,@height]).translate(x:@toolhead_length,y:@toolhead_tip_width),
						cube([0.1,0.1,@height]).translate(y:@toolhead_width)
			)

		# The teeth are currently quite unparametric. Let's try if it works.
		(@toolhead_length/1).round.times do |i|
			res -= cylinder(d:0.8,h:@height).translate(x:(@hinge_area_diameter+@hinge_clearance)/2.0+1.2+i+offset)
		end

		# I'm removing a tiny bit more of material to not not interfere with the gripping mechanism before the "teeth" can engage
		res -= long_slot(d:1,l:1,h:@height).translate(x:(@hinge_area_diameter+@hinge_clearance)/2.0-0.5)

		res

	end

end
