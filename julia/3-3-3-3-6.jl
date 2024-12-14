include("tiling.jl")
include("plot.jl")

A = Point(0, 0)
B = Point(1, 0)

t1 = Tiling()

t(x, y) = add_regular_polygon!(t1, x, y, 3)
q(x, y) = add_regular_polygon!(t1, x, y, 4)
p(n, x, y) = add_regular_polygon!(t1, x, y, n)

add_regular_polygon!(t1, A, B, 6)

t(1,6)
t(1,7)
t(1,8)
t(1,9)
t(2,9)
t(2,10)
t(2,11)
t(3,11)
t(3,12)
t(3,13)
t(4,13)
t(4,14)
t(4,15)
t(5,15)
t(5,16)
t(5,17)
t(6,17)
t(6,18)


demean!(t1.points)

t2 = dual(t1)
t3 = dual(t2)
# t4 = dual(t3)

fig = Figure()
ax = Axis(fig[1, 1], aspect = DataAspect(), title = "Dual Tiling", xlabel = "X", ylabel = "Y")

plot(t1, ax, :blue, text=true)
plot(t2, ax, :red)
plot(t3, ax, :green)
# plot(t4, ax, :yellow)

display(fig)