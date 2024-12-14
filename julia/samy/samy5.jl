include("tiling.jl")
include("plot.jl")

function samy()
	t = Tiling()
	p(x) = add_point!(t, x)
	l(x, y) = link!(t, x, y)
	c(x) = t.points[x]
	ngon(x, y, n) = add_regular_polygon!(t, x, y, n)

	ngon(Point(0, 0), Point(1,0), 12)
	ngon(2,1, 3)
	ngon(13,1, 4)
	ngon(13,15,3)
	ngon(13,16,3)
	ngon(16,15,3)
	ngon(18,15,4)
	ngon(20,19,4)
	ngon(22,21,3)
	ngon(23,21,3)
	ngon(23,24,3)
	ngon(25,24,3)
	ngon(25,26,3)
	ngon(27,26,4)
	ngon(29,28,4)
	ngon(31,30,4)
	ngon(33,32,6)
	ngon(29,31,3)
	ngon(38, 31, 3)
	ngon(31,33,3)
	ngon(39,33,4)
	ngon(38,39,3)
	ngon(41,39,4)
	ngon(38,41,3)

	# symmetry around the center of the dodecagon
	q = centroid([c(x) for x in 1:12])
	f(z) = q + (z - q) * exp(im * 2 * pi / 12)

	for i = 1:12
		for (u, v) in copy(t.edges)
			l(f(t.points[u]), f(t.points[v]))
		end
	end
	

	return t
end

t = samy()

fig = Figure(size = (1000, 1000))
ax = Axis(fig[1, 1], aspect = DataAspect(), title = "Samy", xlabel = "X", ylabel = "Y")

plot(t, ax, :red, show_points = true, text = true)

display(fig)
