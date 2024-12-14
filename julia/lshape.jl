include("tiling.jl")
include("plot.jl")

function l_shape()
	t = Tiling()
	p(x) = add_point!(t, x)
	l(x, y) = link!(t, x, y)

	o = Point(0, 0)
	x = Point(1, 0)
	y = Point(0, 1)

	l(o, 2x)
	l(o, 2y)
	l(2x, 2x + y)
	l(2x + y, x + y)
	l(x + y, x + 2y)
	l(x + 2y, 2y)

	f(z) = 4 * 2^r * x - real(z) + im * imag(z)
	g(z) = real(z) + 4 * 2^r * y - im * imag(z)
	h(z) = z + (1 + 1im) * 2^r

	r = 0

	while r < 4
		for (u, v) in copy(t.edges)
			l(f(t.points[u]), f(t.points[v]))
			l(g(t.points[u]), g(t.points[v]))
			l(h(t.points[u]), h(t.points[v]))
		end
		r += 1
	end

    return t
end

t = l_shape()

fig = Figure(size = (1000, 1000))
ax = Axis(fig[1, 1], aspect = DataAspect(), title = "L shape", xlabel = "X", ylabel = "Y")

plot(t, ax, :blue, text = false)
display(fig)
