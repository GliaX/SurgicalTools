class NeedleDriver <  StraightHemostat
	# I'm inherating the Hemostat because it contains everything that is needed apart from a 
	# toolhead and a few changes in configuration

	def initialize(args={})
		# call Initialize from parent class
		super(args)

		# Height of the arms and the rest apart from the hinge
		@height = 1.8+6.5+0.2 # adjusted to approx dimensions of F 2,9 x 6,5 DIN 7971 
		
		# Thickness of the arms
		@arm_thickness = 6.5

		# Bending radius of the arm 	
		@arm_radius=155
		@arm_angle=20

		# Additional length of straight line towards the grip
		@arm_additional_length = 30

		# spacing between the arms
		@arm_spacing = 5.8

		@hinge_area_height = @height / 2.0

		@hinge_area_diameter = 12
		@hinge_hole_diameter = 3.4
		@hinge_clearance = 1.5 # extra clearance for the hinge, higher values mean more possible rotation

		@toolhead_width = 9	
		@toolhead_tip_width = 6
		@toolhead_length = 25.2
		
		# Layer height, needed for the toolhead
		@layer_height = 0.2

		# Angle of the two parts to each other, only for show
		@opening_angle = 0

		@skip_hinge_hole = true
	end
	
	def view1
		@opening_angle = 15
	end

	def view2
		@opening_angle = -11.2
	end

	def locking_pins
		res = HoldingPins.new(height:@height,valley_height:2.2+0.8,mountain_height:4.6+0.8).output
	end

	def attach_grip(show,y)
		@lower += Grip.new(height:@height).part(show).mirror(y:1).rotate(z:-@arm_angle).translate(y:y/2.0)
		@upper += Grip.new(height:@height).part(show).mirror(y:1).rotate(z:-@arm_angle).translate(y:y/2.0)

		# Attach a bit more material to the grip, which does not work otherwise 	
		# because the size of the pipe is too small
		@lower += cube([5,6,@height]).rotate(z:-@arm_angle).translate(y:y/2.0+3)
		@upper += cube([5,6,@height]).rotate(z:-@arm_angle).translate(y:y/2.0+3)
	end

	def pre_plating_mods
		# create our custom hinge, using a 
		# DIN 7971 bolt F2,9 x 6,5
	  
		hole_dia = 3
		@upper -= cylinder(d:hole_dia,h:@height)
		@lower -= cylinder(d:hole_dia+0.5,h:@height) # Don't make the screw bite into the lower part, just the other one
		
		# hole for the bolt head
		@lower -= cylinder(d:5.6+0.4,h:1.8)

		# support for the bolt hole
		@lower += cylinder(d:hole_dia+0.5-0.15,h:1.8-@layer_height)
		@lower += cylinder(d:5.3,h:@layer_height)

		# since the hinge is so small here, I need to cut excess manually
		@lower -= long_slot(d:@hinge_area_diameter+@hinge_clearance,l:@hinge_area_diameter,h:@hinge_area_height+0.1).translate(x:-@hinge_area_diameter/2.0).rotate(z:60).translate(z:@hinge_area_height)
			
		@upper -= long_slot(d:@hinge_area_diameter+@hinge_clearance,l:@hinge_area_diameter,h:@hinge_area_height+0.1).translate(x:-@hinge_area_diameter/2.0).rotate(z:60)

	end

	def toolhead(args={})
		raise_z = args[:raise_z] || 0 # for hinge

		offset = args[:offset] || 0 # offset for better gripping

		offset-= 6

		res = hull(
						cube([0.1,0.1,@height]),
						cube([0.1,0.1,@height]).translate(x:@toolhead_length),
						cube([0.1,0.1,@height]).translate(x:@toolhead_length,y:@toolhead_tip_width),
						cube([0.1,0.1,@height]).translate(y:@toolhead_width)
			)

		((@toolhead_length/0.5).round-2).times do |i|
			res -= cylinder(d:0.9,h:@height*2).rotate(y:45).translate(x:(@hinge_area_diameter+@hinge_clearance)/2.0+i*1.5+offset)
			res -= cylinder(d:0.9,h:@height*2).rotate(y:-45).translate(x:(@hinge_area_diameter+@hinge_clearance)/2.0+i*1.5+offset)
		end


		# Hinge to toolhead connection
		res += hull(
					cylinder(d:@hinge_area_diameter,h:@hinge_area_height).translate(z:raise_z),
					cube([0.1,0.1,@hinge_area_height]).translate(z:raise_z),
					cube([0.1,0.1,@hinge_area_height]).translate(y:@toolhead_width,z:raise_z)
		)
	



		# I'm removing a tiny bit more of material to not not interfere with the gripping mechanism before the "teeth" can engage
		res -= long_slot(d:1,l:1,h:@height).translate(x:(@hinge_area_diameter+@hinge_clearance)/2.0-0.5)

		res

	end

end
