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

function plot(t::Tiling)
    fig = Figure(size = (800, 800))
    ax = Axis(fig[1, 1], aspect = DataAspect(), xgridvisible = false, ygridvisible = false)
    hidedecorations!(ax)
    hidespines!(ax)

    pts = Dict(i => (real(p), imag(p)) for (i, p) in t.points)

    for (i, adj) in t.adj
        for j in adj
            lines!(ax, [pts[i], pts[j]], color = :black)
        end
    end

    for (i, p) in pts
        text!(ax, p, text = string(i), color = :black)
    end

    scatter!(ax, collect(values(pts)), color = :red)

    return fig
end

t = Tiling()
A = Point(0, 0)
B = Point(1, 0)

rng(x,y,n) = rngon!(t, x, y, n)
tri(x=A,y=B) = r(x,y,3)
squ(x=A,y=B) = r(x,y,4)
hex(x=A,y=B) = r(x,y,6)
oct(x=A,y=B) = r(x,y,8)
dod(x,y) = r(x,y,12)