include("tiling.jl")
include("plot.jl")

import Random
Random.seed!(1)

using Colors

function lshape()
	t = Tiling()
	p(x) = add_point!(t, x)
	l(x, y) = link!(t, x, y)

	p(0)
	p(1)
	p(im)
	p(2)
	p(2im)
	p(2 + im)
	p(1 + im)
	p(1 + 2im)

	ps = [1,2,4,6,7,8,5,3,1]
	for i in 1:8
		l(ps[i], ps[i + 1])
	end

	f(z) = 4 * 2^r * Point(1,0) - real(z) + im * imag(z)
	g(z) = real(z) + 4 * 2^r * Point(0,1) - im * imag(z)
	h(z) = z + (1 + 1im) * 2^r

	r = 0

	while r < 3
		for (u, v) in copy(t.edges)
			l(f(t.points[u]), f(t.points[v]))
			l(g(t.points[u]), g(t.points[v]))
			l(h(t.points[u]), h(t.points[v]))
		end
		r += 1
	end



	return t
end

ndual(t, n) = n == 0 ? t : ndual(dual(t), n - 1)

t = lshape()

fig = Figure(size = (1000, 1000))
ax = Axis(fig[1, 1], aspect = DataAspect(), title = "L Shape", xlabel = "X", ylabel = "Y")

plot(ndual(t, 0), ax, :blue)
plot(ndual(t, 1), ax, :red)

display(fig)
