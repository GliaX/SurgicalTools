#!/usr/bin/ruby1.9.3
require "rubygems"
require "crystalscad"
require "require_all"
include CrystalScad

require_all "lib/**/*.rb"

# To run this project and refresh any changes to the code, run the following command
# in a terminal (make sure you are in the same directory as this file): 
#  observr surgical_tools.observr
#
# This will generate surgical_tools.scad which you can open in OpenSCAD.
# In OpenSCAD make sure that you have the menu item
# Design -> Automatic Reload and Compile 
# activated. 
 

# List of tools this project will make:
# 
# Scissors-like: 
# 	straight hemostat
#		curved hemostat
#   Allis tissue clamp
#		right angle clamp
#		sponge stick
#   towel clamp

# Forceps:
#		Adson's toothed forceps
#   Debakey tissue forceps
#   smooth forceps

# Others:
# 	scalpel handle


res = Surgical_toolsAssembly.new.show

res.save("surgical_tools.scad","$fn=64;")
@@bom.save("bom.txt")

tools = [StraightHemostat,NeedleDriver,TowelClamp,SpongeStick,Forceps,PointedForceps]
# if we have a command line parameter
if ARGV[0]
	tools = get_classes_from_file(ARGV[0])
end
tools.each{|tool| save_all(tool)}




