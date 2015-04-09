class TestPart < CrystalScad::Printed
		
	# I'm making this part to get an experimental design of things that are needed a lot in order to 
	# create the surgical tools, i.e. the hand grips and hinges.
	# This will later on help in making a small library that will help with rapid development
	def initialize()
		
	end

	def part(show)
		# Dummy platform		
		res = cube([20,20,z=5]).center_xy
		res -= cylinder(d:10.5,h:z+0.2).translate(z:-0.1)
		res += hinge_male(show).color("PowderBlue")


	end

	def hinge_male(show)	
		res = cylinder(d:20,h:2).translate(z:-2)
		res += cylinder(d:10,h:5)
		
#		top = cylinder(d1:10,d2:14,h:5).translate(z:1)
#		top *= cube([20,10,10]).center_xy
#		res += top	
#		res -= cube([5,15,10]).center_xy.translate(z:1).color("red")	

	end

end	
