include("../tilings.jl")

using Random
Random.seed!(0)

r = 10
d = rand(Bool, 2r, 2r)

for i in -r:r, j in -r:r
    if i > -r
        add!(t, Point(i, j), Point(i - 1, j))
    end
    if j > -r
        add!(t, Point(i, j), Point(i, j - 1))
    end

    if i > -r && j > -r
        if d[i + r, j + r]
            add!(t, Point(i, j), Point(i - 1, j - 1))
        else
            add!(t, Point(i - 1, j), Point(i, j - 1))
        end
    end
end

fig, ax = plot(t, 15)
display(fig)