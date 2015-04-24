class SpikedForceps < Forceps
	def initialize(args={})
		# Side wall thickness of the grips
		@thickness = args[:thickness] || 3.5
		
		# This is the height, this should be set according to the rest of the part 
		@height = args[:height] || 9

		@front_thickness = 1.5
	end


	def part(show)
		res = side
		res += side.mirror(y:1).translate(y:-13)
		
		# making the rear stronger
		res += cube([13,5,@height]).translate(x:120,y:-9,z:-@height/2.0)
		
		# To counter horizontal movement, add a bolt
		b = Bolt.new(3,10)
		res -= b.output.rotate(x:90).translate(x:45,y:@thickness/2.0)
		res += b.show.rotate(x:90).translate(x:45,y:@thickness/2.0) if show

		# making the other side a long slot instead
		res -= long_slot(d:3.2,h:10,l:4).rotate(x:90).translate(x:45-2,y:-@thickness/2.0-5)


		# move to z = 0 and line up the inner surface to y=0
		res.translate(y:@thickness/2.0, z:@height/2.0)

		res -= cube([40,40,20]).rotate(y:-12).translate(x:-0.1+10,y:-20,z:@front_thickness).color("red")
		res -= cube([10,40,20]).translate(x:-0.1,y:-20,z:@front_thickness).color("red")


		# Trying out to do a spike
		res += polygon(points:[
			[0,0],
			[2,-3],
			[4,0]
		]).linear_extrude(h:@front_thickness).translate(y:1)

		res += polygon(points:[
			[0,0],
			[0,4],
			[2,2],
			[4,4],
			[4,0]
		]).linear_extrude(h:@front_thickness).translate(y:-11.5)


		res
	end

	def side
		pipe = RectanglePipe.new(size:[@height,@thickness],bent_segments:512)
		pipe.line(1)		
		pipe.ccw(3,10)		
		pipe.line(10)		
		pipe.cw(300,5)
		pipe.cw(300,5)
		pipe.line(80)		
		pipe.pipe
	end


end
