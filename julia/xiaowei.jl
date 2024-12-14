include("tiling.jl")
include("plot.jl")

import Random
Random.seed!(1)

using Colors

function xiaowei(r)
	t = Tiling()
	p(x) = add_point!(t, x)
	l(x, y) = link!(t, x, y)

	a,b = size(r)

	# Make grid
	for i in 0:a, j in 0:b
		p(Point(i, j))
		if i > 0
			l(Point(i, j), Point(i - 1, j))
		end
		if j > 0
			l(Point(i, j), Point(i, j - 1))
		end
		if i > 0 && j > 0
			if r[i, j]
				l(Point(i, j), Point(i - 1, j - 1))
			else
				l(Point(i - 1, j), Point(i, j - 1))
			end
		end
	end

	return t
end

ndual(t, n) = n == 0 ? t : ndual(dual(t), n - 1)

k = 20
r = falses(2k - 1, 2k - 1)
r[k, k] = true

t = xiaowei(r)

fig = Figure(size = (1000, 1000))
ax = Axis(fig[1, 1], aspect = DataAspect(), title = "Xiaowei", xlabel = "X", ylabel = "Y")

# plot(ndual(t, 0), ax, :blue)
# plot(ndual(t, 2), ax, :red)
# plot(ndual(t, 4), ax, :green)
# plot(ndual(t, 6), ax, :purple)
plot(ndual(t, 30), ax, :red)
plot(ndual(t, 32), ax, :blue)

display(fig)
