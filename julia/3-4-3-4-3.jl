include("tiling.jl")
include("plot.jl")

A = Point(-1, -1)
B = Point(1, -1)

t1 = Tiling()

t(x, y) = add_regular_polygon!(t1, x, y, 3)
q(x, y) = add_regular_polygon!(t1, x, y, 4)

add_regular_polygon!(t1, A, B, 4)

t(2, 1)
t(3, 2)
t(4, 3)
t(1, 4)

t(2, 5)
t(3, 6)
t(4, 7)
t(1, 8)

q(2, 9)
q(3, 10)
q(4, 11)
q(1, 12)

q(9, 5)
q(10, 6)
q(11, 7)
q(12, 8)

t(6, 13)
t(7, 14)
t(8, 15)
t(5, 16)

t(9, 18)
t(10, 20)
t(11, 22)
t(12, 24)

t(9, 25)
t(10, 26)
t(11, 27)
t(12, 28)

t(19, 13)
t(21, 14)
t(23, 15)
t(17, 16)

q(32, 16)
q(31, 15)
q(30, 14)
q(29, 13)


t2 = dual(t1)
t3 = dual(t2)

fig = Figure()
ax = Axis(fig[1, 1], aspect = 1, title = "Dual Tiling", xlabel = "X", ylabel = "Y")

plot(t1, ax, :blue, text=true)
plot(t2, ax, :red)
plot(t3, ax, :green)

display(fig)