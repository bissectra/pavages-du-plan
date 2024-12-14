include("tiling.jl")
include("plot.jl")

A = Point(0, 0)
B = Point(1, 0)

t1 = Tiling()

t(x, y) = add_regular_polygon!(t1, x, y, 3)
q(x, y) = add_regular_polygon!(t1, x, y, 4)
p(n, x, y) = add_regular_polygon!(t1, x, y, n)

add_regular_polygon!(t1, A, B, 12)

for i in 1:2:11
    p(12, i + 1, i)
    j = mod1(i + 2, 12)
    p(3, j, i+1)
end

p(3, 15, 14)
for i in 20:8:56
    p(3, i+1, i)
end

p(12, 15, 60)
for i in 20:8:56
    p(12, i+3, i)
end


t2 = dual(t1)
t3 = dual(t2)
t4 = dual(t3)

fig = Figure(size = (1000, 1000))
ax = Axis(fig[1, 1], aspect = DataAspect(), title = "Dual Tiling", xlabel = "X", ylabel = "Y")

plot(t1, ax, :blue, text=false)
plot(t2, ax, :red)
plot(t3, ax, :green)
plot(t4, ax, :yellow)

display(fig)