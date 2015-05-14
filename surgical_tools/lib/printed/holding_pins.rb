class HoldingPins < CrystalScad::Printed
	view :tooth
	view :connection_wall
	
	def initialize(args={})
		@holding_pins_width = 12

		# additional wall to connect towards the grip
		@additional_connection_wall = 5

		# height of the base, which is starts at the grip
		@base_height = args[:height] || 7 

		# height of the valleys
		@valley_height = args[:valley_height] || 2.2
		@valley_spacing = args[:valley_spacing] || 2.1
		@first_tooth_extra_valley_spacing = args[:first_tooth_extra_valley_spacing] || 0.8
		@mountain_height = args[:mountain_height] || 5.8 
		@mountain_thickness = args[:mountain_thickness] || 0.9

		@angle_width = 2.1

		@skip = args[:skip] || [false,false,false]		
	
		@rotations = args[:rotations] || [0,0,0]
		@extra_valley_spacings = args[:extra_valley_spacings] || [0,0,0]

	end

	def tooth
		points = []		
		points << [0,0]
		points << [0,@valley_height] # valley 
		points << [-1,@mountain_height] # valley 				
		points << [@mountain_thickness,@mountain_height] # valley 
		points << [@mountain_thickness+@angle_width,@valley_height] 
		points << [@mountain_thickness+@angle_width,0] 
		polygon(points:points).linear_extrude(height:@holding_pins_width)  
	end

	def connection_wall
		points = []		
		points << [0,0]
		points << [0,@base_height] # the connection from the grip
		points << [@additional_connection_wall,@base_height] # additional wall to connect to the grip
		points << [@additional_connection_wall+@angle_width,@valley_height] # triangle top 
		points << [@additional_connection_wall+@angle_width,0] # triangle top 
		polygon(points:points).linear_extrude(height:@holding_pins_width)  	
	end

	def valley(spacing=@valley_spacing)
		points = []		
		points << [0,0]
		points << [0,@valley_height]		
		points << [spacing,@valley_height]
		points << [spacing,0]
		polygon(points:points).linear_extrude(height:@holding_pins_width)  		
	end

	def part(show)
		res = connection_wall
		x = @additional_connection_wall	+ @angle_width 
		x += @first_tooth_extra_valley_spacing
		3.times do |i|	
			x += @valley_spacing
			if @extra_valley_spacings[i] > 0
				res += valley(@extra_valley_spacings[i]).translate(x:x)			
				x += @extra_valley_spacings[i]			
			end				
	
			unless @skip[i] == true			
				if @rotations[i].to_f != 0.0
					res += tooth.rotate(y:@rotations[i]).translate(x:x)
				else
					res += tooth.translate(x:x)				
				end

			end

			x += @angle_width + @mountain_thickness
		end
		res += valley(x)

	
		res.rotate(x:90).rotate(z:90).translate(y:-@additional_connection_wall)
	end

end
