Point = Complex{Float64}

struct Tiling
	adj::Dict{Int, Vector{Int}} # ordered by angle
	points::Dict{Int, Point}
	function Tiling()
		adj = Dict{Int, Vector{Int}}()
		points = Dict{Int, Point}()
		new(adj, points)
	end
end

function Base.:(≈)(p::Point, q::Point)
	return abs(p - q) < 1e-6
end

function mex(s::AbstractSet)
	i = 1
	while i in s
		i += 1
	end
	return i
end

function add!(tiling::Tiling, p::Point)
	# certify that the point is not already in the tiling
	for (i, q) in tiling.points
		if p ≈ q
			return i
		end
	end
	i = mex(keys(tiling.points))
	tiling.points[i] = p
	tiling.adj[i] = []
	return i
end

function Base.delete!(tiling::Tiling, i::Int)
	delete!(tiling.points, i)
	for (j, adj) in tiling.adj
		# remove i from adj, which is a vector, so delete! doesn't work
		for k in 1:length(adj)
			if adj[k] == i
				deleteat!(adj, k)
				break
			end
		end
	end
	delete!(tiling.adj, i)
end

function Base.delete!(tiling::Tiling, p::Point)
	for (i, q) in tiling.points
		if p ≈ q
			delete!(tiling, i)
			return
		end
	end
end

function add!(tiling::Tiling, p::Point, q::Point)
	i = add!(tiling, p)
	j = add!(tiling, q)
	push!(tiling.adj[i], j)
	push!(tiling.adj[j], i)

	# sort the adjacency list by angle
	sort!(tiling.adj[i], by = x -> angle(tiling.points[x] - p))
	sort!(tiling.adj[j], by = x -> angle(tiling.points[x] - q))
	return i, j
end

function add!(tiling::Tiling, i::Int, j::Int)
	add!(tiling, tiling.points[i], tiling.points[j])
end

function Base.delete!(tiling::Tiling, p::Point, q::Point)
	# remove edge p-q from the tiling
	# find the indices of p and q
	i = -1
	j = -1
	for (k, r) in tiling.points
		if p ≈ r
			i = k
		end
		if q ≈ r
			j = k
		end
	end
	if i == -1 || j == -1
		return
	end

	# remove j from i's adjacency list
	for k in 1:length(tiling.adj[i])
		if tiling.adj[i][k] == j
			deleteat!(tiling.adj[i], k)
			break
		end
	end

	# remove i from j's adjacency list
	for k in 1:length(tiling.adj[j])
		if tiling.adj[j][k] == i
			deleteat!(tiling.adj[j], k)
			break
		end
	end

	# remove i and j if they have no neighbors
	if isempty(tiling.adj[i])
		delete!(tiling, i)
	end
	if isempty(tiling.adj[j])
		delete!(tiling, j)
	end

	return
end

function rngon!(t::Tiling, p::Int, q::Int, n::Int)
	return rngon!(t, t.points[p], t.points[q], n)
end

function polygon!(t::Tiling, points::Vector{Point})
	# add a polygon to the tiling with vertices points
	# return the indices of the vertices
	is = [add!(t, p) for p in points]
	for i in 1:length(is)
		j = mod1(i + 1, length(is))
		add!(t, t.points[is[i]], t.points[is[j]])
	end
	return is
end

function polygon!(t::Tiling, is::Vector{Int})
	# add a polygon to the tiling with vertices is
	# return the indices of the vertices
	for i in 1:length(is)
		j = mod1(i + 1, length(is))
		add!(t, is[i], is[j])
	end
	return is
end

function rngon!(t::Tiling, p::Point, q::Point, n::Int)
	# add an n-gon to the tiling with vertices p and q
	# return the indices of the vertices
	i, j = add!(t, p, q)
	p, q = t.points[i], t.points[j]
	points = [p]
	for k in 1:n-1
		p, q = q, q + (q - p) * cis(2π / n)
		add!(t, p, q)
		push!(points, p)
	end
	return points
end

function Base.show(io::IO, t::Tiling)
	println(io, "Tiling")
	println(io, "  points:")
	for (i, p) in t.points
		println(io, "    $i: $p")
	end
	println(io, "  adj:")
	for (i, adj) in t.adj
		println(io, "    $i: $adj")
	end
end

using Makie, GLMakie

function plot(t::Tiling; ax = nothing, fig=nothing, show_points = false, show_labels = false, color = :black)
    if fig == nothing
        fig = Figure(size = (1200, 1200))
    end

    if ax == nothing
        ax = Axis(fig[1, 1], aspect = DataAspect(), xgridvisible = false, ygridvisible = false)
        hidedecorations!(ax)
        hidespines!(ax)
    end

	pts = Dict(i => (real(p), imag(p)) for (i, p) in t.points)

	for (i, adj) in t.adj
		for j in adj
			i < j || continue
			lines!(ax, [pts[i], pts[j]], color = color)
		end
	end

	if show_points
		scatter!(ax, collect(values(pts)), color = :red)
	end

	if show_labels
		for (i, p) in pts
			text!(ax, p, text = string(i), color = :black)
		end
	end

	return fig, ax
end

function edges(t::Tiling)
	edges = Set{Tuple{Int, Int}}()
	for (i, adj) in t.adj
		for j in adj
			i < j || continue
			push!(edges, (i, j))
		end
	end
	return edges
end

function add_transformation!(t::Tiling, f)
		new_edges = [f(t.points[i]) => f(t.points[j]) for (i, j) in edges(t)]
	new_points = [f(t.points[i]) for i in keys(t.points)]
	for (p, q) in new_edges
		add!(t, p, q)
	end
	for p in new_points
		add!(t, p)
	end
end

# reflection by the line through p and q
reflection(z, p, q) = p + (q - p) * conj((z - p) / (q - p))

function next(t::Tiling, i::Int, j::Int)
    # let F be the face with edge i -> j. return the next edge in F
    # find i in j's adjacency list
    for k in 1:length(t.adj[j])
        if t.adj[j][k] == i
            return t.adj[j][mod1(k - 1, length(t.adj[j]))]
        end
    end
    error("edge $i -> $j not found")
end

function face(t::Tiling, i::Int, j::Int)
    # let F be the face with edge i -> j. return the list of edges in F
    face = [i, j]
    while true
        k = next(t, face[end - 1], face[end])
        if k == i
            break
        end
        push!(face, k)
    end
    # rotate to begin with the smallest index
    i = argmin(face)
    return vcat(face[i:end], face[1:i-1])
end

function faces(t::Tiling)
    faces = Set{Vector{Int}}()
    for (i, adj) in t.adj
        for j in adj
            i < j || continue
            push!(faces, face(t, i, j))
        end
    end
    return sort(collect(faces), by = x -> (length(x), x))
end

function gcentroid(ps::Vector{Point})
    xs = [real(p) for p in ps]
	ys = [imag(p) for p in ps]
	push!(xs, xs[1])
	push!(ys, ys[1])
	area = 0
	cx = 0
	cy = 0
	for i in 1:length(xs) - 1
		area += xs[i] * ys[i + 1] - xs[i + 1] * ys[i]
		cx += (xs[i] + xs[i + 1]) * (xs[i] * ys[i + 1] - xs[i + 1] * ys[i])
		cy += (ys[i] + ys[i + 1]) * (xs[i] * ys[i + 1] - xs[i + 1] * ys[i])
	end
	area /= 2
	cx /= 6 * area
	cy /= 6 * area
	return Point(cx, cy)
end

function acentroid(ps::Vector{Point})
    return sum(ps) / length(ps)
end

centroid = acentroid

function dual(t::Tiling)
    # return the dual of the tiling
    outer_face = faces(t)[end]
    dual = Tiling()
    for (u, v) in edges(t)
        f1 = face(t, u, v)
        f2 = face(t, v, u)
        if f1 == outer_face || f2 == outer_face
            continue
        end
        add!(dual, centroid([t.points[i] for i in f1]), centroid([t.points[i] for i in f2]))
    end

    # remove edges with only one neighbor
    for (i, adj) in copy(dual.adj)
        if length(adj) == 1
            delete!(dual, i)
        end
    end

    return dual
end

t = Tiling()
A = Point(0, 0)
B = Point(1, 0)

rng(x, y, n) = rngon!(t, x, y, n)
