using DOIHS
using ValidatedNumerics
using Distributions
using Base.Test

@testset "function approximation" begin
    
    function approxerror(basis, f, n=100)
        α = basis_matrix(basis) \ f(collocation_points(basis))
        x = linspace(basis, n)
        y = basis_matrix(basis, x) * α
        maximum(abs(y-f(x)) for (x,y) in zip(x,y))
    end
    
    @test approxerror(ChebyshevBasis(10), exp) ≤ 1e-9
    
    @test approxerror(IntervalAB(0..pi, ChebyshevBasis(10)), sin) ≤ 1e-7

end

@testset "quadrature" begin

    d = Truncated(Normal(0,1), -1, 2)
    q = quadrature(10, d)
    m = mean(d)
    @test isapprox(q(identity), m; rtol=1e-6)
    @test isapprox(q(x->(x-m)^2), var(d); rtol=1e-6)

end
