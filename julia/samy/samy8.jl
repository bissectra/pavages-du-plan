include("tiling.jl")
include("plot.jl")

function samy()
	t = Tiling()
	p(x) = add_point!(t, x)
	l(x, y) = link!(t, x, y)
	c(x) = t.points[x]
	ngon(x, y, n) = add_regular_polygon!(t, x, y, n)

	ngon(Point(0, 0), Point(1, 0), 12)
	ngon(5,4, 6)
	ngon(5,16,4)
	ngon(7,6,3)
	ngon(8,7,12)
	ngon(18,17,4)
	ngon(9,27,4)
	ngon(29,26,12)
	ngon(10,30,12)
	ngon(4,3,4)
	ngon(3,2,6)
	ngon(2,1,4)
	ngon(1,12,3)
	ngon(52,12,4)
	
	return t
end

t = samy()
demean!(t.points)

ndual(t, n) = n == 0 ? t : ndual(dual(t), n - 1)

fig = Figure(size = (1000, 1000))
ax = Axis(fig[1, 1], aspect = DataAspect(), title = "Samy", xlabel = "X", ylabel = "Y")

plot(t, ax, :blue, text = true)

display(fig)
