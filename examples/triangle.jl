include("../tilings.jl")

C = Point(-0.5, 1)
polygon!(t, [A, B, C])
M = (B + C) / 2

add_transformation!(t, p -> p + (M - p) * 2)
for i ∈ 1:5
	add_transformation!(t, p -> p + (B - A))
	add_transformation!(t, p -> p + (C - A))
end

fig, ax = plot(t, 3)
display(fig)
