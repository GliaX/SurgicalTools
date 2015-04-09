class Grip < CrystalScad::Printed

	# This will be the standard grip used for all scissors-like tools	
	def initialize(args={})

		# Dimensions of the grip holes, make sure that x >= y
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
		# the inner cut will be removed later on

		# we need the outer right and top points later:	
		outer_right = (@grip_x-@grip_y)+@grip_y/2.0 + @thickness
		top = @grip_y/2+@thickness

		# in order to create a connecting wall, I'm taking the upper-right part of the part, which means
		# I'll put it in a new variable and intersect a cube in that area 	
		arc = res
		arc *= cube([@grip_x/2.0,@grip_y,@height]).center_x.translate(x:@grip_x/2.0)		
		# that part that was just intersected is now put together with the hull() command
		# to a 1x1x@height cube. Translating it to the outer_right / top point minus one, which is the cube size
		res += hull(arc,
								cube([1,1,@height]).translate(x:outer_right-1, y:top-1)
		)


		# removing the inner cut
		res -= inner_cut		
		
		
		# moving the part, so x = 0 is the outermost right point and y is the top point
		res = res.translate(x:-outer_right,y:-top)

	
	
		# This has been used to check my dimensions, might be useful somewhere
#		res += Ruler.new(height:@height+1,rotation:0).show.translate(x:-13)

		res
	end


end
