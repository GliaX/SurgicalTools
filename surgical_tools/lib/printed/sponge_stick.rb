class SpongeStick <  StraightHemostat
	# I'm inherating the Hemostat because it contains everything that is needed apart from a 
	# toolhead and a few changes in configuration

	def initialize(args={})
		# call Initialize from parent class
		super(args)

		# Height of the arms and the rest apart from the hinge
		@height = 7

		# Thickness of the arms
		@arm_thickness = 10

		# Bending radius of the arm 	
		@arm_radius=155
		@arm_angle=18

		# Additional length of straight line towards the grip
		@arm_additional_length = 30

		# spacing between the arms
		@arm_spacing = 5.8

		@hinge_area_height = @height / 2.0

		@hinge_area_diameter = 23
		@hinge_hole_diameter = 3.4
		@hinge_clearance = 1.5 # extra clearance for the hinge, higher values mean more possible rotation

		@toolhead_witdh = 6	
		@toolhead_tip_witdh = 6
		@toolhead_length = 45
		@toolhead_slot_length = 5		
		@toolhead_slot_diameter= 12		
		@toolhead_slot_inner_diameter = 8

		@toolhead_raise_z = @height-@hinge_area_height

		# Layer height, needed for the toolhead
		@layer_height = 0.2

		# Angle of the two parts to each other, only for show
		@opening_angle = 0

		@holding_pin_rotation = 4.0

	end
	
	def view1
		@opening_angle = 15
	end

	def view2
		@opening_angle = -8.4
	end


	def toolhead(args={})
		raise_z = args[:raise_z] || 0 # for hinge

		offset = args[:offset] || 0 # offset for better gripping


		# make a connection from the hinge before raising the toolhead
		@raised_toolhead_offset= 18

		res = hull(
						cube([0.1,0.1,@height]),
						cube([0.1,0.1,@height]).translate(x:@raised_toolhead_offset),
						cube([0.1,0.1,@height]).translate(x:@raised_toolhead_offset,y:@toolhead_tip_witdh-0.1),
						cube([0.1,0.1,@height]).translate(y:@toolhead_witdh-0.1)
			)
		towel_clamp = long_slot(d:@toolhead_slot_diameter,l:@toolhead_length,h:@toolhead_witdh)			
		towel_clamp -= long_slot(d:@toolhead_slot_inner_diameter,l:@toolhead_slot_length,h:@toolhead_witdh+0.2).translate(x:@toolhead_length-@toolhead_slot_length,z:-0.1)		
						

		res += towel_clamp.rotate(x:-90).translate(x:@raised_toolhead_offset,z:@toolhead_slot_diameter/2.0)
		

		# I'm removing a tiny bit more of material to not not interfere with the gripping mechanism before the "teeth" can engage
		#res -= long_slot(d:1,l:1,h:@height).translate(x:(@hinge_area_diameter+@hinge_clearance)/2.0-0.5)
		

		# Hinge to toolhead connection
		res += hull(
					cylinder(d:@hinge_area_diameter,h:@hinge_area_height).translate(z:raise_z),
					cube([0.1,0.1,@hinge_area_height]).translate(z:raise_z),
					cube([0.1,0.1,@hinge_area_height]).translate(y:@toolhead_witdh,z:raise_z)
		)


		res

	end

end
