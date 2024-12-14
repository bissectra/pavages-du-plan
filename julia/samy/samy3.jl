include("tiling.jl")
include("plot.jl")

function samy()
	t = Tiling()
	p(x) = add_point!(t, x)
	l(x, y) = link!(t, x, y)
	c(x) = t.points[x]
	ngon(x, y, n) = add_regular_polygon!(t, x, y, n)

	ngon(Point(0, 0), Point(0, 1), 12)
	ngon(2,1, 12)
	ngon(13,12,12)
	l(30,15)
	l(10,23)
	l(3,22)

	ngon(26,27,4)
	ngon(27,28,3)
	ngon(25,26,3)
	ngon(28,29,4)
	ngon(29,30,3)
	ngon(30,14,4)
	ngon(14,13,3)
	ngon(32,31,6)
	ngon(11,35,3)
	ngon(23,24,3)

	q = centroid([c(x) for x in (1,12,13)])
	f(z) = q + (z - q) * exp(im * 2 * pi / 3)

	# symmetrize according to f
	for i = 1:2
		for (u, v) in copy(t.edges)
			l(f(t.points[u]), f(t.points[v]))
		end
	end

	ngon(15,30,12)
	ngon(17,56,12)
	ngon(19,64,12)
	ngon(21,72,12)
	ngon(5,78,12)
	ngon(7,86,12)
	ngon(9,94,12)
	ngon(25,100,12)
	ngon(27,108,12)

	return t
end

t = samy()

fig = Figure(size = (1000, 1000))
ax = Axis(fig[1, 1], aspect = DataAspect(), title = "Samy", xlabel = "X", ylabel = "Y")

plot(t, ax, :red, show_points = true, text = true)

display(fig)
