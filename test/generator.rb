#!/usr/bin/env ruby
# Test generator for ARKO classes.

@target = nil

ARGV.each do|a|
	s = 0
	if a == "-h" or a == "--help"
		puts "Test generator for height map project in x86."
		puts "Usage:"
		puts "\tgenerator type"
		puts "Options:"
		puts "\ttype\tNumber of function used to generate test" 
		puts "Possible options"
		puts "\t-h, --help\t Display this message."
		puts "\t-u, --usage\tDisplay usage message."
		puts "Functions available:"
		puts "\t0\tVertical scope."
		puts "\t1\tHorizontal scope."
		puts "\t2\tCorner scope."
		exit
	elsif a == "-u" or a == "--usage"
		puts "Usage:"
		puts "\tgenerator type"
		puts "\twhere type is number of function used to generate test."
		exit
	elsif a == "-o"
		s = 1
	elsif s == 1
		s = 0
		@target = a
	else
		@function = a.to_i
	end

end
if @target == nil
	@target = "test.txt"
end

array = []
if @function == 0 
	(1..201).each do |m|
		inner_array = []
		(1..201).each do |n|
			inner_array << m
		array << inner_array
		end
	end
end

if @function == 1
	(1..201).each do |m|
		inner_array = []
		(1..201).each do |n|
			inner_array << n
		array << inner_array
		end
	end
end

if @function == 2
	(1..201).each do |m|
		inner_array = []
		(1..201).each do |n|
			inner_array << m+n
		array << inner_array
		end
	end
end

file = File.open(@target, "w+")
array.each do |line|
	line.each do |element|
		file.print element
		file.print " "
	end
	file.print "\n"
end
file.close
