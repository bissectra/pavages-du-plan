include("tiling.jl")
include("plot.jl")

A = Point(0, 0)
B = Point(1, 0)

t1 = Tiling()

p(n, x, y) = add_regular_polygon!(t1, x, y, n)
l(x, y) = link!(t1, x, y)

p(4, A, B)
l(1,3)
p(4,2,1)
p(4,2,6)
p(4,3,2)
l(1,6)
l(2,7)
l(3,8)

add_point!(t1, 4)



t2 = dual(t1)

fig = Figure(size = (1000, 1000))
ax = Axis(fig[1, 1], aspect = DataAspect(), title = "Dual Tiling", xlabel = "X", ylabel = "Y")

plot(t1, ax, :blue, text=true)
plot(t2, ax, :red)

display(fig)