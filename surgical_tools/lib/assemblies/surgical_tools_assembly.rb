class Surgical_toolsAssembly < CrystalScad::Assembly

	def part(show)
		res = StraightHemostat.new.output
	end

end
