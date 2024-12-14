include("tiling.jl")
include("plot.jl")

function read(filename)
	A = Point(0, 0)
	B = Point(1, 0)
	t = Tiling()

	p(n, x, y) = add_regular_polygon!(t, x, y, n)
	open(filename) do file
		isfirstline = true
		for line in eachline(file)
			if isfirstline
				isfirstline = false
				add_regular_polygon!(t, A, B, parse(Int, line))
				continue
			end
			n, x, y = split(line, ",")
			p(parse(Int, n), parse(Int, x), parse(Int, y))
		end
	end

	demean!(t.points)

	fig = Figure(size = (1000, 1000))
	ax = Axis(fig[1, 1], aspect = DataAspect(), xlabel = "X", ylabel = "Y")

	plot(t, ax, :blue, text = true)

	display(fig)
end


# listen for changes in the file
function watch(filename)
	# get the last modified time of the file
	last_modified = 0
	while true
		sleep(0.1)
		if isfile(filename)
			current_modified = stat(filename).mtime
			if current_modified > last_modified
				last_modified = current_modified
				read(filename)
			end
		end
	end
end