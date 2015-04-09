class Surgical_toolsAssembly < CrystalScad::Assembly

	def part(show)
		res = StraightHemostat.new.show
	end

end
