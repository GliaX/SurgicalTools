class NeedleDriver <  StraightHemostat
	# I'm inherating the Hemostat because it contains everything that is needed apart from a 
	# toolhead and a few changes in configuration

	def initialize(args={})
		# call Initialize from parent class
		super(args)

		# Height of the arms and the rest apart from the hinge
		@height = 7
		# Thickness of the arms
		@arm_thickness = 11

		# Bending radius of the arm 	
		@arm_radius=155
		@arm_angle=20

		# Additional length of straight line towards the grip
		@arm_additional_length = 30

		# spacing between the arms
		@arm_spacing = 5.8

		@hinge_area_height = @height / 2.0

		@hinge_area_diameter = 23
		@hinge_hole_diameter = 3.4
		@hinge_clearance = 1.5 # extra clearance for the hinge, higher values mean more possible rotation

		@toolhead_width = 12	
		@toolhead_tip_width = 6
		@toolhead_length = 25.2
		
		# Layer height, needed for the toolhead
		@layer_height = 0.2

		# Angle of the two parts to each other, only for show
		@opening_angle = 0

	end
	
	def view1
		@opening_angle = 15
	end

	def view2
		@opening_angle = -11.2
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
