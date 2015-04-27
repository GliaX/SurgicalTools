class SpongeStick <  StraightHemostat
	# I'm inherating the Hemostat because it contains everything that is needed apart from a 
	# toolhead and a few changes in configuration

	def initialize(args={})
		# call Initialize from parent class
		super(args)

		# Thickness of the arms
		@arm_thickness = 8

		# Bending radius of the arm 	
		@arm_radius=135
		@arm_angle=18

		# Additional length of straight line towards the grip
		@arm_additional_length = 20

		# spacing between the arms
		@arm_spacing = 5.8

		@hinge_area_diameter = 23
		@hinge_hole_diameter = 3.4
		@hinge_clearance = 1.5 # extra clearance for the hinge, higher values mean more possible rotation

		# the part coming from the hinge
		@toolhead_width = 6.5	
		# the attachment
		@attached_toolhead_height = 4	
		@toolhead_tip_width = 4
		@toolhead_length = 30

		# Height of the arms and the rest apart from the hinge
		@height = 8

		@hinge_area_height = @height / 2.0


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
		@add_support_for_lower = true

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
		#toolhead_adapter_male
	end

	def print_plate
		res	= @lower.mirror(z:1)
		res += @upper.mirror(y:1).mirror(z:1).rotate(z:5)
		res = res.color("PaleTurquoise")
		res -= cylinder(d:@hinge_area_diameter,h:@layer_height*2).translate(z:-@hinge_area_height-@layer_height)
		res += support_grid.translate(z:-@hinge_area_height-@layer_height).color("red")
		res += support_grid.rotate(z:90).translate(z:-@hinge_area_height).color("pink")


		res
	end

	# Support grid for printing the hinge area
	def support_grid
		res = nil		
		20.times do |x|
			res += cylinder(d:0.6,h:@hinge_area_diameter).rotate(x:90).translate(x:@hinge_area_diameter/2.0-x*1.8,y:@hinge_area_diameter/2.0)
		end

		res *= cylinder(d:@hinge_area_diameter,h:@layer_height)
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
			res -= cylinder(d:1.4,h:@toolhead_slot_diameter+0.2).rotate(x:-90).translate(x:x_offset+i*1.8,y:-@toolhead_slot_diameter/2.0-0.1)	
		end

		res.rotate(x:180)
	end

	def toolhead(args={})
		raise_z = args[:raise_z] || 0 # for hinge
		offset = args[:offset] || 0 # offset for better gripping
		y_offset = -3

		
		
		# position on the ground
#		if raise_z == 0
#			res.translate(z:Math::sqrt(3)/2.0*(@toolhead_attachment_diameter/2.0))
#		end

		# FIXME Reinforcement of the toolhead
		res = hull(
			cube([0.1,0.1,@hinge_area_height]),
			cube([0.1,0.1,@hinge_area_height]).translate(y:@hinge_area_diameter/2.0-1),
			cube([0.1,0.1,@hinge_area_height]).translate(x:@hinge_area_diameter/2.0+5.5, y:-y_offset+1.1),
			cube([0.1,0.1,@hinge_area_height]).translate(x:@hinge_area_diameter/2.0+6, y:-y_offset-2.75)
		)

		# position on the top if making the upper part
		if raise_z != 0
			res.translate(z:@hinge_area_height)
		end

		res += towel_clamp.rotate(x:90).translate(x:@raised_toolhead_offset-9	,y:@toolhead_width/2.0+y_offset,z:0)
		
		# Hinge to toolhead connection
		res += hull(
					cylinder(d:@hinge_area_diameter,h:@hinge_area_height).translate(z:raise_z),
					cube([0.1,0.1,@hinge_area_height]).translate(z:raise_z),
					cube([0.1,0.1,@hinge_area_height]).translate(y:@toolhead_width,z:raise_z)
		)


		res

	end

end
