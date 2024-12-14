include("../tilings.jl")

function add!(t::Tiling, n::Int)
	if length(t.points) < 2
		return rngon!(t, A, B, n)
	end
	outer_face = faces(t)[end]
	a, b = outer_face[1], outer_face[2]
	rngon!(t, a, b, n)
end

seq = [
    12, 3, 3, 4, 6, 4, 3, 3, 3, 4, 6, 4, 3, 3, 4, 3, 12,
	3, 4, 4, 3, 4, 3, 4, 4, 3, 3, 3, 3, 4, 3, 3, 3, 3,
	3, 4, 3, 3, 3, 3, 4, 4, 3, 4, 3, 4, 3, 3, 4, 6, 4,
	3, 3, 3, 4, 6, 4, 3, 3, 4, 3, 3, 3, 3, 4, 3, 3, 3,
]

for n in seq
	add!(t, n)
end


fig, ax = plot(t, show_labels = true)
display(fig)
