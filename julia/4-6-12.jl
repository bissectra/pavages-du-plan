include("tiling.jl")
include("plot.jl")

A = Point(0, 0)
B = Point(0, 1)

t1 = Tiling()

t(x, y) = add_regular_polygon!(t1, x, y, 3)
q(x, y) = add_regular_polygon!(t1, x, y, 4)
p(n, x, y) = add_regular_polygon!(t1, x, y, n)

add_regular_polygon!(t1, A, B, 12)

for i in 1:2:12
    p(6, i+1, i)
    j = mod1(i+2, 12)
    p(4, j, i+1)
end

for i in 13:4:33
    p(12, i+1, i)
    p(4, i+2, i+1)
end

for i in 43:8:83
    p(6, i+1, i)
end

for i in 38:8:78
    p(4, i+1, i)
    p(6, i+2, i+1)
    p(4, i+3, i+2)
    p(6, i+4, i+3)
    p(4, i+5, i+4)
end

for i in 85:2:95
    p(12, i+1, i)
end

demean!(t1.points)

t2 = dual(t1)
t3 = dual(t2)
t4 = dual(t3)

fig = Figure()
ax = Axis(fig[1, 1], aspect = DataAspect(), title = "Dual Tiling", xlabel = "X", ylabel = "Y")

plot(t1, ax, :blue, text=false)
plot(t2, ax, :red)
plot(t3, ax, :green)
plot(t4, ax, :yellow)

display(fig)