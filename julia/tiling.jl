using Printf
Point = Complex{Float64}

eps = 1e-6

struct Tiling
	points::Vector{Point}
	edges::Set{Tuple{Int, Int}}
	Tiling() = new(Point[], Set{Tuple{Int, Int}}())
end

function Base.show(io::IO, t::Tiling)
	@printf(io, "Tiling with %d points and %d edges:\n", length(t.points), length(t.edges))
	@printf(io, "Points:\n")
	for (i, p) in enumerate(t.points)
		@printf(io, "  %2d: (%.2f, %.2f)\n", i, real(p), imag(p))
	end
	@printf(io, "Edges:\n")
	for (i, (a, b)) in enumerate(t.edges)
		@printf(io, "  %2d: (%d, %d)\n", i, a, b)
	end
end

function add_point!(tiling::Tiling, point)
	i = findfirst(isapprox.(tiling.points, point, atol = eps))
	isnothing(i) || return tiling.points[i]
	push!(tiling.points, point)
	return tiling.points[end]
end

function link!(tiling::Tiling, i::Int, j::Int)
	if i == j
		return
	end
	if i > j
		i, j = j, i
	end
	n = length(tiling.points)
	if i > n || j > n
		error("Index out of bounds")
	end
	if (i, j) in tiling.edges
		return
	end
	push!(tiling.edges, (i, j))
end

function link!(tiling::Tiling, p::Point, q::Point)
	# find the indices of the points
	i = findfirst(isapprox.(tiling.points, p, atol = eps))
	j = findfirst(isapprox.(tiling.points, q, atol = eps))
	# if the points are not in the list, add them
	if isnothing(i)
		i = length(tiling.points) + 1
		push!(tiling.points, p)
	end
	if isnothing(j)
		j = length(tiling.points) + 1
		push!(tiling.points, q)
	end
	if i == j
		return
	end
	if i > j
		i, j = j, i
	end
	# add the edge
	push!(tiling.edges, (i, j))
end

function add_regular_polygon!(tiling::Tiling, a::Point, b::Point, n::Int)
	w = exp(2 * π * im / n)
	c = b - a
	p = a
	vertices = Point[p]
	for i ∈ 1:n-1
		p += c
		push!(vertices, p)
		c *= w
	end
	for i ∈ 1:n
		link!(tiling, vertices[i], vertices[mod1(i + 1, n)])
	end
	return tiling
end

function add_regular_polygon!(tiling::Tiling, i::Int, j::Int, n::Int)
	add_regular_polygon!(tiling, tiling.points[i], tiling.points[j], n)
end

function Base.findfirst(v::Vector, x)
	for i in eachindex(v)
		if v[i] == x
			return i
		end
	end
	return nothing
end


function adjlist(t::Tiling)
	adjs = Dict{Int, Vector{Int}}()
	for (i, j) in t.edges
		adjs[i] = get(adjs, i, Int[])
		adjs[j] = get(adjs, j, Int[])
		push!(adjs[i], j)
		push!(adjs[j], i)
	end
	# sort adjacency lists by polar angle
	for (i, adj) in adjs
		adj = sort(adj, by = p -> angle(t.points[p] - t.points[i]))
		adjs[i] = adj
	end
	return adjs
end

function next(adjlist, edge::Tuple{Int, Int})
	u, v = edge
	v in adjlist[u] || error("Edge $edge not found in tiling")
	i = findfirst(adjlist[v], u)
	j = mod1(i - 1, length(adjlist[v]))
	return v, adjlist[v][j]
end

function face(adjlist, edge::Tuple{Int, Int})
	u, v = edge
	u1, v1 = u, v
	ans = [u]
	while v1 != u
		push!(ans, v1)
		u1, v1 = next(adjlist, (u1, v1))
	end
	return ans
end

function faces(adjs)
	visited = Set{Tuple{Int, Int}}()
	ans = Vector{Vector{Int}}()
	for (u, adj) in adjs
		for v in adj
			(u, v) in visited && continue
			f = face(adjs, (u, v))
			push!(ans, f)
			for i in 1:length(f)-1
				push!(visited, (f[i], f[i+1]))
			end
			push!(visited, (f[end], f[1]))
		end
	end
	# remove largest face, which is the outer face
	sort!(ans, by = length)
	# pop!(ans)
	return ans
end

function centroid(points)
	x = [real(p) for p in points]
	y = [imag(p) for p in points]
	push!(x, x[1])
	push!(y, y[1])
	n = length(points)

	A = 0.5 * sum(x[i] * y[i+1] - x[i+1] * y[i] for i in 1:n)
	Cx = 1 / (6 * A) * sum((x[i] + x[i+1]) * (x[i] * y[i+1] - x[i+1] * y[i]) for i in 1:n)
	Cy = 1 / (6 * A) * sum((y[i] + y[i+1]) * (x[i] * y[i+1] - x[i+1] * y[i]) for i in 1:n)
	return Cx + im * Cy
end

function dual(tiling::Tiling)
	adjs = adjlist(tiling)
	dual_tiling = Tiling()
	fs = faces(adjs)
	outer_length = length(fs[end])

	for (u, v) in tiling.edges
		f1 = face(adjs, (u, v))
		f2 = face(adjs, (v, u))

		if length(f1) == outer_length || length(f2) == outer_length
			continue
		end

		c1 = centroid([tiling.points[i] for i in f1])
		c2 = centroid([tiling.points[i] for i in f2])

		link!(dual_tiling, c1, c2)
	end

	# for each edge, verify that the corresponding face has at least 3 vertices. Otherwise, remove the edge.
	dajds = adjlist(dual_tiling)
	for (u, v) in copy(dual_tiling.edges)
		f1 = face(dajds, (u, v))
		f2 = face(dajds, (v, u))
		if length(f1) < 3 || length(f2) < 3
			delete!(dual_tiling.edges, (u, v))
		end
	end
	return dual_tiling
end

function demean!(points)
	# Find the centroid of the points
	centroid = sum(points) / length(points)

	# Subtract the centroid from each point
	for i in 1:length(points)
		points[i] -= centroid
	end
end
