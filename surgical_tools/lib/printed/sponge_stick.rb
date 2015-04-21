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
		@toolhead_length = 75

		# Attachment configuration the toolhead
		@toolhead_attachment_length = 40
		# Diameter of the heaxagonal attachment
		@toolhead_attachment_diameter = 7
 		# extra inner margin of the negative part 
		@toolhead_attachment_margin = 0.2 

		@toolhead_slot_length = 5		
		@toolhead_slot_diameter= 16		
		@toolhead_slot_inner_diameter = 11
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

	def view3 
		towel_clamp
	end
	
	def view4
		toolhead_adapter_male
	end

	def output1
		res = towel_clamp
		res += towel_clamp.translate(y:@toolhead_slot_diameter+1)
	end

	def print_plate
		res	= @lower
		res += @upper.translate(y:@holding_pins_length*2).mirror(z:1).translate(x:14,y:6,z:@height)
		res
	end

	# this is the actual clamp, as seperate part
	def towel_clamp
		# the basic shape
		res = long_slot(d:@toolhead_slot_diameter,l:@toolhead_length,h:@attached_toolhead_height).translate(x:@toolhead_slot_diameter)
		# create a cube to have the left end square		
		res += cube([@toolhead_slot_diameter,@toolhead_slot_diameter,@attached_toolhead_height]).center_y			

		# the actual tip of the toolhead
		res -= long_slot(d:@toolhead_slot_inner_diameter,l:@toolhead_slot_length,h:@attached_toolhead_height+0.2).translate(x:@toolhead_slot_diameter+@toolhead_length-@toolhead_slot_length,z:-0.1)		

		x_offset = @toolhead_slot_diameter/1.5+@toolhead_length-@toolhead_slot_length-1
		(@toolhead_slot_length+@toolhead_slot_diameter/2.0).ceil.times do |i| 
			res -= cylinder(d:1.4,h:@toolhead_slot_diameter+0.2).rotate(x:-90).translate(x:x_offset+i*1.8,y:-@toolhead_slot_diameter/2.0-0.1, z:@attached_toolhead_height)	
		end
						
		# Adapter to the toolhead

		res -= toolhead_adapter_female.translate(x:-0.01,y:0,z:@attached_toolhead_height/2.0).color("red")

		res
	end

	# This provides the adapter where the toolhead can be glued on
	def toolhead_adapter_female
		cylinder(d:@toolhead_attachment_diameter+@toolhead_attachment_margin,h:@toolhead_attachment_length,fn:6).rotate(y:90)
	end

	def toolhead_adapter_male
		# h is 5mm longer because I move it 5 back towards the hinge in the toolhead method 
		cylinder(d:@toolhead_attachment_diameter,h:@toolhead_attachment_length+5,fn:6).rotate(z:30).rotate(y:90)
	end



	def toolhead(args={})
		raise_z = args[:raise_z] || 0 # for hinge
		offset = args[:offset] || 0 # offset for better gripping

		res = toolhead_adapter_male.translate(x:@hinge_area_diameter/2.0-5, y:4.5)

		if raise_z != 0
			res.translate(z:-Math::sqrt(3)/2.0*(@toolhead_attachment_diameter/2.0)+@height)
		else
			res.translate(z:Math::sqrt(3)/2.0*(@toolhead_attachment_diameter/2.0))
		end

		
		res += towel_clamp.rotate(x:90).translate(x:@raised_toolhead_offset-12,y:@toolhead_width-1.5+4.5,z:@toolhead_width/2.0) if args[:show]
		

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
