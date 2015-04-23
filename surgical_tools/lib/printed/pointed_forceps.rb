class PointedForceps < Forceps
	def initialize(args={})
		# Side wall thickness of the grips
		@thickness = args[:thickness] || 3.5
		
		# This is the height, this should be set according to the rest of the part 
		@height = args[:height] || 9
	end


	def part(show)
		res = side
		res += side.mirror(y:1).translate(y:-13)
		
		# making the rear stronger
		res += cube([13,5,@height]).translate(x:100,y:-9,z:-@height/2.0)
		

		res -= cube([40,40,20]).rotate(y:-15).translate(x:-0.1,y:-20,z:-3).color("red")

		# To counter horizontal movement, add a bolt
		b = Bolt.new(3,10)
		res -= b.output.rotate(x:90).translate(x:32,y:@thickness/2.0)
		res += b.show.rotate(x:90).translate(x:32,y:@thickness/2.0) if show

		# making the other side a long slot instead
		res -= long_slot(d:3.3,h:10,l:4).rotate(x:90).translate(x:32-2,y:-@thickness/2.0-5)

		res
	end

	def side
		pipe = RectanglePipe.new(size:[@height,@thickness],bent_segments:512)
		pipe.line(1)		
		pipe.ccw(3,10)		
		pipe.line(10)		
		pipe.cw(300,5)
		pipe.cw(300,5)
		pipe.line(60)		
		pipe.pipe
	end


end
