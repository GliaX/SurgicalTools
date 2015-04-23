class PointedForceps < Forceps


	def part(show)
		res = side
		res += side.mirror(y:1).translate(y:-13)

		res -= cube([40,40,20]).rotate(y:-15).translate(x:-0.1,y:-20,z:-3).color("red")

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
