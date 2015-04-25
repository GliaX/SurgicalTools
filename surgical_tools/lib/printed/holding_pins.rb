class HoldingPins < CrystalScad::Printed

	def initialize(args={})
		@holding_pins_width = 12

		# additional wall to connect towards the grip
		@additional_connection_wall = 3.5

		# height of the base, which is starts at the grip
		@base_height = args[:height] || 7 

		# height of the valleys
		@valley_height = 2.0	
		@valley_spacing = 1.3
		@mountain_height = 4.9 
		@mountain_thickness = 0.8

		# the first tooth is tiny bit smaller
		@first_tooth_mountain_height = @mountain_height - 0.0


	end

	def part(show)

		# I'm drawing the holding pins as a 2d polygon here and will extrude it later.
		points = []
		points << [0,0] # starting point
		points << [0,@base_height] # the connection from the grip

		x = @additional_connection_wall
		points << [x,@base_height] # additional wall to connect to the grip


		x += 2.5		
		points << [x,@valley_height] # triangle top 
			
		
		# teeth	
		3.times do |i| 		
			if i == 2 
				@mountain_height = @first_tooth_mountain_height
			end

			# making the first valley from the grip a bit longer
			x += 0.4 if i == 0

			x += @valley_spacing 
	
			points << [x,@valley_height] # valley 
			points << [x-0.3,@mountain_height] # triangle 
	
			# I'm adding a bit more material to the tops, so they won't be printed single walled
			x += @mountain_thickness
			points << [x,@mountain_height] # triangle 

		
			# i'm making the last increment smaller, so it will not have excess material beyond the last tooth
			if i == 2 		
				x += 1
			else
				x += 1.5 
			end	
			points << [x,@valley_height] # bottom point on the right of the triangle 

		end



		
		# last point in x axis connects back to zero
		points << [x,@valley_height]		
		points << [x,0]		
	
		res = polygon(points:points)  

#	I used this to debug the teeth gripping with the other side 
#		res += polygon(points:points).mirror(y:1).mirror(x:1).translate(x:x+1.45,y:5.9) 

		

		res.linear_extrude(height:@holding_pins_width).rotate(x:90).rotate(z:90).translate(y:-@additional_connection_wall)
	end


end
