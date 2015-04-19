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

		# the part coming from the hinge
		@toolhead_width = 6	
		# the attachment
		@attached_toolhead_height = 9	
		@toolhead_tip_width = 4
		@toolhead_length = 45
		@toolhead_slot_length = 5		
		@toolhead_slot_diameter= 12		
		@toolhead_slot_inner_diameter = 8
		# make a connection from the hinge before raising the toolhead
		@raised_toolhead_offset= 26

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

	def print_plate(lower,upper)
		res	= lower
		res += upper.translate(y:@holding_pins_length*2).mirror(z:1).translate(x:14,y:6,z:@height)
		res += towel_clamp.rotate(x:90).rotate(z:-15).translate(x:-50,y:32)
		res += towel_clamp.rotate(x:90).rotate(z:-15).translate(x:-65,y:10)
		res
	end

	# this is the actual clamp, as seperate part
	def towel_clamp
		res = long_slot(d:@toolhead_slot_diameter,l:@toolhead_length,h:@attached_toolhead_height)			
		# create a knurled surface on top
		res *= knurled_cube([@toolhead_slot_length*3.1,@toolhead_width,@toolhead_slot_diameter-0.6]).rotate(x:-90).translate(x:@toolhead_length-@toolhead_slot_length*3.1+@toolhead_slot_diameter/2.0-0.6,y:-@toolhead_width+0.3,z:@attached_toolhead_height)		
		# add the base (again) with height minus the knurls 	
		res += long_slot(d:@toolhead_slot_diameter,l:@toolhead_length,h:@attached_toolhead_height-0.5)			
		# remove the long slot
		res -= long_slot(d:@toolhead_slot_inner_diameter,l:@toolhead_slot_length,h:@attached_toolhead_height+0.2).translate(x:@toolhead_length-@toolhead_slot_length,z:-0.1)		
						
		res -= toolhead_adapter.rotate(x:-90).translate(x:-17.7,y:-@toolhead_width/2.0,z:(@attached_toolhead_height-@toolhead_width/2.0)+1)

#		res += toolhead_adapter.rotate(x:90).translate(x:-17.7-20,y:@toolhead_width/2.0,z:(@attached_toolhead_height-@toolhead_width)/2.0)

		res
	end

	# This provides the adapter where the toolhead can be glued on
	def toolhead_adapter
		hull(
			cube([0.1,0.1,@height]),
			cube([0.1,0.1,@height]).translate(x:@raised_toolhead_offset),
			cube([0.1,0.1,@height]).translate(x:@raised_toolhead_offset,y:@toolhead_tip_width-0.1),
			cube([0.1,0.1,@height]).translate(y:@toolhead_width-0.1)
		)
	end

	def toolhead(args={})
		raise_z = args[:raise_z] || 0 # for hinge

		offset = args[:offset] || 0 # offset for better gripping




		res = toolhead_adapter


		res += towel_clamp.rotate(x:90).translate(x:@raised_toolhead_offset-8,y:@toolhead_width,z:@toolhead_width/2.0) if args[:show]
		

		# I'm removing a tiny bit more of material to not not interfere with the gripping mechanism before the "teeth" can engage
		#res -= long_slot(d:1,l:1,h:@height).translate(x:(@hinge_area_diameter+@hinge_clearance)/2.0-0.5)
		

		# Hinge to toolhead connection
		res += hull(
					cylinder(d:@hinge_area_diameter,h:@hinge_area_height).translate(z:raise_z),
					cube([0.1,0.1,@hinge_area_height]).translate(z:raise_z),
					cube([0.1,0.1,@hinge_area_height]).translate(y:@toolhead_width,z:raise_z)
		)


		res

	end

end
