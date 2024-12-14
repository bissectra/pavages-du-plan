include("tiling.jl")
include("plot.jl")

A = Point(0, 0)
B = Point(1, 0)

t1 = Tiling()

t(x, y) = add_regular_polygon!(t1, x, y, 3)
q(x, y) = add_regular_polygon!(t1, x, y, 4)
p(n, x, y) = add_regular_polygon!(t1, x, y, n)

add_regular_polygon!(t1, A, B, 3)

t(2,1)
t(4,1)
t(2,4)

t(4,5)
t(6,4)
t(7,5)
t(7,8)
t(6,8)

t(7,9)
t(8,7)
t(10,8)
t(11,9)
t(10,13)
t(11,12)
t(12,13)

t(11,14)
t(12,11)
t(13,12)
t(15,13)
t(16,14)
t(16,17)
t(17,18)
t(18,19)
t(15,19)

t(3,2)
t(1,3)
t(5,1)
t(1,23)
t(22,2)
t(2,6)
t(19,18)
t(21,19)
t(26,27)

t(16,20)
t(17,16)
t(28,29)

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