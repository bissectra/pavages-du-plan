include("tiling.jl")
include("plot.jl")

function samy()
	t = Tiling()
	p(x) = add_point!(t, x)
	l(x, y) = link!(t, x, y)
	ngon(x, y, n) = add_regular_polygon!(t, x, y, n)

	ngon(Point(0, 0), Point(1, 0), 6)
	ngon(2,1,6)
	ngon(2,10,6)
	ngon(3,13,3)
	ngon(4,3,3)
	ngon(13,12,4)
	ngon(14,13,4)
	ngon(4,14,4)
	ngon(5,4,4)
	ngon(15,12,3)
	ngon(5,20,3)
	ngon(14,17,3)
	ngon(16,15,4)
	ngon(17,16,4)
	ngon(20,19,4)
	ngon(19,18,4)
	ngon(18,17,3)
	ngon(17,25,3)
	ngon(28,18,3)
	ngon(29,25,3)
	ngon(28,29,3)
	ngon(29,30,3)
	ngon(15,21,6)
	ngon(22,20,6)
	return t
end

t = samy()

fig = Figure(size = (1000, 1000))
ax = Axis(fig[1, 1], aspect = DataAspect(), title = "Samy", xlabel = "X", ylabel = "Y")

plot(t, ax, :red, show_points = true, text = true)

display(fig)
