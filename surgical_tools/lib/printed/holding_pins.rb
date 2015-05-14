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
		@valley_spacing = args[:valley_spacing] || 0.9+1
		@mountain_height = args[:mountain_height] || 4.6 
		@mountain_thickness = args[:mountain_thickness] || 0.8

		@angle_width = 2.5

	end

	def tooth
		points = []		
		points << [0,0]
		points << [0,@mountain_height] # valley 
		points << [@mountain_thickness,@mountain_height] # valley 
		points << [@mountain_thickness+@angle_width,@valley_height] # valley 
		points << [@mountain_thickness+@angle_width,0] # valley 
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

	def valley
		points = []		
		points << [0,0]
		points << [0,@valley_height]		
		points << [@valley_spacing,@valley_height]
		points << [@valley_spacing,0]
		polygon(points:points).linear_extrude(height:@holding_pins_width)  		
	end

	def part(show)
		res = connection_wall
		x = @additional_connection_wall	+ @angle_width


		3.times do 	
			res += valley.translate(x:x)
			x += @valley_spacing
			res += tooth.translate(x:x)
			x += 2.5 + @mountain_thickness
		end

		res.rotate(x:90).rotate(z:90).translate(y:-@additional_connection_wall)
	end

end
