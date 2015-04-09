class Grip < CrystalScad::Printed

	# This will be the standard grip used for all scissors-like tools	
	def initialize(args={})

		# Dimensions of the grip holes
		@grip_x = args[:grip_x] || 25
		@grip_y = args[:grip_y] || 20

		# Side wall thickness of the grips
		@thickness = args[:thickness] || 3
		
		# This is the height, this should be set according to the rest of the part 
		@height = args[:height] || 5		
	end

	def part(show)
		# to keep it simple, the grip is basically represented by a long slot substracted by a smaller long slot.
		res = long_slot(d:@grip_y+@thickness*2,l:@grip_x-@grip_y,h:@height)			
		inner_cut = long_slot(d:@grip_y,l:@grip_x-@grip_y,h:@height+0.2).translate(z:-0.1)

		res -= inner_cut		

		# This has been used to check my dimensions, might be useful somewhere
		#	res += Ruler.new(height:@height+1,rotation:0).show.translate(x:-13)

		res
	end


end
