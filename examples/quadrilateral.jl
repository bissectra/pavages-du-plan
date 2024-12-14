include("../tilings.jl")

p(x) = t.points[x]
v(x,y) = p(y) - p(x)
n(x) = x / abs(x)
C, D = Point(1.5,1.3), Point(-0.5, 1)
# C, D = Point(1,1), Point(0.8,0.2)
polygon!(t, [A, B, C,D])

add_transformation!(t, x-> x+v(1,3))
add_transformation!(t, x-> (p(4) + p(3)) - x)
add_transformation!(t, x-> (p(2) + p(3)) - x)
add_transformation!(t, x-> (p(16) + p(11)) - x)
add_transformation!(t, x-> (p(16) + p(1)) - x)
add_transformation!(t, x-> (p(40) + p(33)) - x)
add_transformation!(t, x-> (p(43) + p(34)) - x)

polygon!(t, [77,32,88,93])
polygon!(t, [64,70,38,56])
add!(t,70,21)
add!(t,78,46)
add!(t,15,23)

fig, ax = plot(t, 3)
display(fig)
