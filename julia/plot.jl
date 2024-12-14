using Makie, GLMakie

function plot(t::Tiling, ax, color; text = false, show_points = false)
	# Convert the points to a format that can be plotted
	points = [(real(p), imag(p)) for p in t.points]

	# Plot lines
	for (i, j) in t.edges
		lines!(ax, [points[i], points[j]], color = color)
	end

	# Overlay the points
	if show_points
		scatter!(ax, points, color = :red, markersize = 10)
	end

	# plot point numbers over the points
	if text
		for (i, p) in enumerate(points)
			text!(ax, p, text = string(i), color = :black)
		end
	end

	return ax
end
