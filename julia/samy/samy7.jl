include("tiling.jl")
include("plot.jl")

function samy()
	t = Tiling()
	p(x) = add_point!(t, x)
	l(x, y) = link!(t, x, y)
	c(x) = t.points[x]
	ngon(x, y, n) = add_regular_polygon!(t, x, y, n)

	ngon(Point(0, 0), Point(1, 0), 4)
	ngon(2,1,4)
	ngon(2,6,4)
	ngon(2,8,4)
	ngon(8,7,3)
	ngon(8,10,3)
	ngon(9, 8,3)
	ngon(9,11,4)
	ngon(9,13,3)
	ngon(12,11,4)
	ngon(15,10,6)
	ngon(13,12,4)
	ngon(12,16,4)
	ngon(15,20,4)
	ngon(16,24,4)


	# square symmetry
	q = c(2)
	f(z) = q + (z - q) * exp(im * pi / 2)

	for i = 1:4
		for (u, v) in copy(t.edges)
			l(f(t.points[u]), f(t.points[v]))
		end
	end
	
	return t
end

t = samy()
demean!(t.points)

ndual(t, n) = n == 0 ? t : ndual(dual(t), n - 1)

fig = Figure(size = (1000, 1000))
ax = Axis(fig[1, 1], aspect = DataAspect(), title = "Samy", xlabel = "X", ylabel = "Y")

plot(t, ax, :blue, show_points = true, text = true)

display(fig)
