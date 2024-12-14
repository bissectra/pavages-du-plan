include("tiling.jl")
include("plot.jl")

function samy()
	t = Tiling()
	p(x) = add_point!(t, x)
	l(x, y) = link!(t, x, y)
	c(x) = t.points[x]
	ngon(x, y, n) = add_regular_polygon!(t, x, y, n)

	ngon(Point(0, 0), Point(1, 0), 12)
	ngon(2,1, 12)
	ngon(3,22, 12)
	ngon(30,29,12)
	ngon(24,23,12)
	ngon(28,27,12)
	ngon(46,45,12)

	ngon(21,23,3)
	ngon(24,25,3)
	ngon(26,27,3)
	ngon(28,29,3)
	ngon(30,4,3)
	ngon(3,22,3)
	ngon(61,62,6)
	ngon(61,62,3)
	ngon(63,64,3)
	ngon(65,66,3)
	
	ngon(49, 60, 3)
	ngon(49,68,4)
	ngon(60,59, 4)
	ngon(68, 70, 3)
	ngon(68, 71, 3)
	ngon(50, 69, 6)
	ngon(53,52,6)
	l(75,74)
	ngon(69, 71, 4)
	ngon(71,70, 4)
	l(79,81)
	ngon(81,80, 4)
	ngon(72,79, 4)
	l(73,85)
	ngon(82,80,3)
	ngon(79,81,6)
	ngon(87,83, 3)
	ngon(89,83,4)
	ngon(84,88,3)
	ngon(84,91,4)
	ngon(75,74,4)
	ngon(76,94,6)
	ngon(93,73,6)
	l(95,100)
	ngon(89,90, 4)
	ngon(89,102,3)
	l(87,103)
	ngon(92,91,4)
	ngon(91,88,3)
	l(104,106)
	ngon(88,87,6)
	ngon(106,108,6)
	ngon(107,103,6)
	ngon(108,107,6)
	l(99,105)
	ngon(97,96,3)
	ngon(114,113,3)
	ngon(113,112,3)
	ngon(113,119,3)
	ngon(120,119,3)
	ngon(110,109,3)
	ngon(111,110,3)
	ngon(110,122,3)
	ngon(123,124,3)
	l(120,118)
	l(118,115)
	l(116,122)

	ll = [121, 120, 118, 115, 116, 122, 124, 125]

	for i = 1:7
		ngon(ll[i+1], ll[i], 3)
	end

	ll = 126:132

	for i = 1:6
		l(ll[i], ll[i+1])
	end


	# hexagonal symmetry
	q = c(67)
	f(z) = q + (z - q) * exp(im * 2 * pi / 6)

	for i = 1:6
		for (u, v) in copy(t.edges)
			l(f(t.points[u]), f(t.points[v]))
		end
	end

	ngon(27,47,4)
	ngon(47,48,3)
	ngon(48,49,4)
	ngon(49,50,3)
	ngon(50,51,4)
	ngon(51,52,3)
	ngon(52,53,4)
	ngon(53,54,3)
	ngon(54,32,4)
	ngon(32,31,3)
	ngon(31,28,4)

	# triangle symmetry
	g(z) = q + (z - q) * exp(im * 2 * pi / 3)

	for i = 1:3
		for (u, v) in copy(t.edges)
			l(g(t.points[u]), g(t.points[v]))
		end
	end


	return t
end

t = samy()
demean!(t.points)

ndual(t, n) = n == 0 ? t : ndual(dual(t), n - 1)

fig = Figure(size = (1000, 1000))
ax = Axis(fig[1, 1], aspect = DataAspect(), title = "Samy", xlabel = "X", ylabel = "Y")

plot(t, ax, :red)
plot(ndual(t, 1), ax, :blue)

display(fig)
