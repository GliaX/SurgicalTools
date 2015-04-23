class Forceps < CrystalScad::Printed


	def initialize(args={})
		# Side wall thickness of the grips
		@thickness = args[:thickness] || 3
		
		# This is the height, this should be set according to the rest of the part 
		@height = args[:height] || 7.5		
	end

	def part(show)
		
		
		res = side
		res += side.mirror(y:1).translate(y:-13)
		
		
	
		res
	end

	def side
		pipe = RectanglePipe.new(size:[@height,@thickness],bent_segments:512)
		pipe.line(1)		
		pipe.ccw(3,10)		
		pipe.line(10)		
		pipe.cw(300,5)
		pipe.cw(300,5)
		pipe.line(40)		
		pipe.pipe
	end


end
