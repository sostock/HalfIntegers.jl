import HalfIntegers

struct MyHalfInt <: HalfInteger
    val::HalfInt
end

MyHalfInt(x::MyHalfInt) = x

HalfIntegers.half(::Type{MyHalfInt}, x) = MyHalfInt(half(HalfInt, x))
HalfIntegers.twice(x::MyHalfInt) = twice(x.val)

@testset "Custom types" begin
    @testset "Construction" begin
        @test MyHalfInt(2.5) isa MyHalfInt
        @test MyHalfInt(3) isa MyHalfInt
        @test MyHalfInt(3//2) isa MyHalfInt
        @test_throws InexactError MyHalfInt(2.6)
        @test half(MyHalfInt, 1) === MyHalfInt(1/2)
        @test onehalf(MyHalfInt) === MyHalfInt(1/2)
        @test one(MyHalfInt) === MyHalfInt(1)
        @test zero(MyHalfInt) === MyHalfInt(0)
    end

    @testset "Conversion" begin
        @test big(MyHalfInt(3//2)) isa BigHalfInt
        @test big(MyHalfInt(3//2)) == 3/2
        @test HalfInteger(MyHalfInt(5/2)) === MyHalfInt(5/2)
        @test HalfInt(MyHalfInt(5/2)) === HalfInt(5/2)
        @test complex(MyHalfInt(5/2)) === Complex(MyHalfInt(5/2), MyHalfInt(0))
        @test float(MyHalfInt(5/2)) === 2.5
        @test Rational(MyHalfInt(5/2)) === 5//2
        @test Float64(MyHalfInt(5/2)) === 2.5
        @test Bool(MyHalfInt(1)) === true
        @test UInt32(MyHalfInt(4)) === UInt32(4)
        @test_throws InexactError Integer(MyHalfInt(3/2))
        @test_throws InexactError Int(MyHalfInt(3/2))
        @test_throws InexactError UInt(MyHalfInt(-1))
    end

    @testset "Properties" begin
        @test isfinite(MyHalfInt(2))
        @test ishalfinteger(MyHalfInt(3/2))
        @test isinteger(MyHalfInt(3))
        @test !isinteger(MyHalfInt(3/2))
        @test iszero(MyHalfInt(0))
        @test !iszero(MyHalfInt(1/2))
        @test isone(MyHalfInt(1))
        @test !isone(MyHalfInt(1/2))
        @test numerator(MyHalfInt(3/2)) === 3
        @test denominator(MyHalfInt(3/2)) === 2
        @test numerator(MyHalfInt(4)) === 4
        @test denominator(MyHalfInt(4)) === 1
    end

    @testset "Comparison" begin
        @test MyHalfInt(2) == MyHalfInt(2)
        @test MyHalfInt(2) != MyHalfInt(5/2)
        @test MyHalfInt(2) < MyHalfInt(5/2)
        @test MyHalfInt(2) ≤ MyHalfInt(5/2)
    end

    @testset "Hashing" begin
        @test hash(MyHalfInt(1)) === hash(1)
        @test hash(MyHalfInt(1/2)) === hash(1//2)
    end

    @testset "Trigonometry" begin
        for x = [typemax(HalfInt), typemax(HalfInt)-HalfInt(1/2),
                 typemax(HalfInt)-HalfInt(1), typemax(HalfInt)-HalfInt(3/2),
                 typemin(HalfInt), typemin(HalfInt)+HalfInt(1/2),
                 typemin(HalfInt)+HalfInt(1), typemin(HalfInt)+HalfInt(3/2)]
            @test sinpi(MyHalfInt(x)) === sinpi(x)
            @test cospi(MyHalfInt(x)) === cospi(x)
            @test sincospi(MyHalfInt(x)) === sincospi(x)
        end
    end

    @testset "string" begin
        @test string(MyHalfInt(3/2)) === "3/2"
        @test string(MyHalfInt(-4)) === "-4"
    end

    @testset "Arithmetic (not customized)" begin
        @test +MyHalfInt(3/2) === HalfInt(3/2)
        @test -MyHalfInt(3/2) === HalfInt(-3/2)
        @test MyHalfInt(2) + MyHalfInt(3/2) === HalfInt(7/2)
        @test MyHalfInt(2) - MyHalfInt(3/2) === HalfInt(1/2)
        @test MyHalfInt(7/2) * MyHalfInt(2) === 7.0
        @test MyHalfInt(7/2) / MyHalfInt(2) === 1.75
        @test MyHalfInt(2) \ MyHalfInt(7/2) === 1.75
        @test MyHalfInt(7/2) // MyHalfInt(2) === 7//4
        @test div(MyHalfInt(7/2), MyHalfInt(3/2)) == 2
        @test fld(MyHalfInt(7/2), MyHalfInt(3/2)) == 2
        @test cld(MyHalfInt(7/2), MyHalfInt(3/2)) == 3
        @test rem(MyHalfInt(7/2), MyHalfInt(3/2)) === HalfInt(1/2)
        @test mod(MyHalfInt(7/2), MyHalfInt(3/2)) === HalfInt(1/2)
        @test fld1(MyHalfInt(7/2), MyHalfInt(3/2)) == 3
        @test mod1(MyHalfInt(7/2), MyHalfInt(3/2)) === HalfInt(1/2)
        @test 2^MyHalfInt(5/2) ≈ √32
        @test MyHalfInt(2)^4 ≈ 16
        @test abs(MyHalfInt(-7/2)) === HalfInt(7/2)
        @test abs2(MyHalfInt(-7/2)) === 12.25
        @test sign(MyHalfInt(0)) == 0
        @test sign(MyHalfInt(-1/2)) == -1
        @test sign(MyHalfInt(3)) == 1
        @test signbit(MyHalfInt(0)) === false
        @test signbit(MyHalfInt(3)) === false
        @test signbit(MyHalfInt(-1/2)) === true
        @test flipsign(MyHalfInt(3), -1) === HalfInt(-3)
        @test flipsign(MyHalfInt(5/2), 0) === HalfInt(5/2)
        @test flipsign(MyHalfInt(5/2), MyHalfInt(7/2)) === HalfInt(5/2)
        @test round(MyHalfInt(5/2)) === HalfInt(2)
        @test round(MyHalfInt(5/2), RoundNearest) === HalfInt(2)
        @test round(MyHalfInt(5/2), RoundNearestTiesAway) === HalfInt(3)
        @test round(MyHalfInt(5/2), RoundNearestTiesUp) === HalfInt(3)
        @test round(MyHalfInt(5/2), RoundToZero) === HalfInt(2)
        @test round(MyHalfInt(5/2), RoundDown) === HalfInt(2)
        @test round(MyHalfInt(5/2), RoundUp) === HalfInt(3)
        @test round(Int, MyHalfInt(5/2)) === 2
        @test round(Int, MyHalfInt(5/2), RoundNearest) === 2
        @test round(Int, MyHalfInt(5/2), RoundNearestTiesAway) === 3
        @test round(Int, MyHalfInt(5/2), RoundNearestTiesUp) === 3
        @test round(Int, MyHalfInt(5/2), RoundToZero) === 2
        @test round(Int, MyHalfInt(5/2), RoundDown) === 2
        @test round(Int, MyHalfInt(5/2), RoundUp) === 3
        @test ceil(MyHalfInt(7/2)) === HalfInt(4)
        @test floor(MyHalfInt(7/2)) === HalfInt(3)
        @test trunc(MyHalfInt(7/2)) === HalfInt(3)
        @test ceil(Int, MyHalfInt(7/2)) === 4
        @test floor(Int, MyHalfInt(7/2)) === 3
        @test trunc(Int, MyHalfInt(7/2)) === 3
    end

    Base.promote_rule(::Type{MyHalfInt}, T::Type{<:Real}) = promote_type(HalfInt, T)

    @testset "Promotion" begin
        @test MyHalfInt(2) == 2
        @test MyHalfInt(2) == 2//1
        @test MyHalfInt(2) == 2.0
        @test MyHalfInt(2) != nextfloat(2.0)
        @test MyHalfInt(3/2) < 2.6
        @test MyHalfInt(2)^MyHalfInt(4) ≈ 16
        @test MyHalfInt(2) + 3 === HalfInt(5)
    end

    @testset "Ranges" begin
        @testset "UnitRange" begin
            @test MyHalfInt(1/2):MyHalfInt(5) isa UnitRange{MyHalfInt}
            @test MyHalfInt(1/2):MyHalfInt(5) === MyHalfInt(1/2):MyHalfInt(9/2)
            @test first(MyHalfInt(1/2):MyHalfInt(5)) === MyHalfInt(1/2)
            @test last(MyHalfInt(1/2):MyHalfInt(5)) === MyHalfInt(9/2)
            @test length(MyHalfInt(1/2):MyHalfInt(5)) == 5
            @test isempty(MyHalfInt(1):MyHalfInt(1/2))
            @test 2.5 ∈ MyHalfInt(1/2):MyHalfInt(5)
            @test !any(isinteger, MyHalfInt(1/2):MyHalfInt(5))
        end

        @testset "StepRange" begin
            @test MyHalfInt(2):MyHalfInt(1/2):MyHalfInt(5) isa StepRange{MyHalfInt,MyHalfInt}
            @test MyHalfInt(2):MyHalfInt(2):MyHalfInt(5) === MyHalfInt(2):MyHalfInt(2):MyHalfInt(4)
            @test first(MyHalfInt(2):MyHalfInt(1/2):MyHalfInt(5)) === MyHalfInt(2)
            @test last(MyHalfInt(2):MyHalfInt(1/2):MyHalfInt(5)) === MyHalfInt(5)
            @test length(MyHalfInt(2):MyHalfInt(1/2):MyHalfInt(5)) == 7
            @test 2.5 ∈ MyHalfInt(2):MyHalfInt(1/2):MyHalfInt(5)
        end

        @test @inferred(intersect(MyHalfInt(1/2):MyHalfInt(2), MyHalfInt(3/2):MyHalfInt(3))) === MyHalfInt(3/2):MyHalfInt(3/2)
        @test isempty(intersect(MyHalfInt(1/2):MyHalfInt(2), MyHalfInt(1):MyHalfInt(3)))
        @test @inferred(intersect(MyHalfInt(3/2):MyHalfInt(3/2):MyHalfInt(15/2), MyHalfInt(2):MyHalfInt(1):MyHalfInt(9))) ==
            3:3:6
        @test @inferred(reverse(MyHalfInt(1/2):MyHalfInt(3/2))) == MyHalfInt(3/2):MyHalfInt(-1):MyHalfInt(1/2)
    end

    Base.:+(x::MyHalfInt) = x
    Base.:+(x::MyHalfInt, y::MyHalfInt) = MyHalfInt(x.val + y.val)

    Base.:-(x::MyHalfInt) = MyHalfInt(-x.val)
    Base.:-(x::MyHalfInt, y::MyHalfInt) = MyHalfInt(x.val - y.val)

    Base.mod(x::MyHalfInt, y::MyHalfInt) = MyHalfInt(mod(x.val, y.val))
    Base.rem(x::MyHalfInt, y::MyHalfInt) = MyHalfInt(rem(x.val, y.val))

    Base.:*(x::MyHalfInt, y::MyHalfInt) = twice(x)*twice(y)//4
    Base.:/(x::MyHalfInt, y::MyHalfInt) = twice(x)//twice(y)

    @testset "Arithmetic (customized)" begin
        @test +MyHalfInt(3/2) === MyHalfInt(3/2)
        @test -MyHalfInt(3/2) === MyHalfInt(-3/2)
        @test MyHalfInt(2) + MyHalfInt(3/2) === MyHalfInt(7/2)
        @test MyHalfInt(2) - MyHalfInt(3/2) === MyHalfInt(1/2)
        @test MyHalfInt(7/2) * MyHalfInt(2) === 7//1
        @test MyHalfInt(7/2) / MyHalfInt(2) === 7//4
        @test MyHalfInt(2) \ MyHalfInt(7/2) === 7//4
        @test MyHalfInt(7/2) // MyHalfInt(2) === 7//4
        @test div(MyHalfInt(7/2), MyHalfInt(3/2)) == 2
        @test fld(MyHalfInt(7/2), MyHalfInt(3/2)) == 2
        @test cld(MyHalfInt(7/2), MyHalfInt(3/2)) == 3
        @test rem(MyHalfInt(7/2), MyHalfInt(3/2)) === MyHalfInt(1/2)
        @test mod(MyHalfInt(7/2), MyHalfInt(3/2)) === MyHalfInt(1/2)
        @test fld1(MyHalfInt(7/2), MyHalfInt(3/2)) == 3
        @test mod1(MyHalfInt(7/2), MyHalfInt(3/2)) === MyHalfInt(1/2)
        @test 2^MyHalfInt(5/2) ≈ √32
        @test MyHalfInt(2)^4 ≈ 16
        @test abs(MyHalfInt(-7/2)) === MyHalfInt(7/2)
        @test abs2(MyHalfInt(-7/2)) === 49//4
        @test sign(MyHalfInt(0)) == 0
        @test sign(MyHalfInt(-1/2)) == -1
        @test sign(MyHalfInt(3)) == 1
        @test signbit(MyHalfInt(0)) === false
        @test signbit(MyHalfInt(3)) === false
        @test signbit(MyHalfInt(-1/2)) === true
        @test flipsign(MyHalfInt(3), -1) === MyHalfInt(-3)
        @test flipsign(MyHalfInt(5/2), 0) === MyHalfInt(5/2)
        @test flipsign(MyHalfInt(5/2), MyHalfInt(7/2)) === MyHalfInt(5/2)
        @test round(MyHalfInt(5/2)) === MyHalfInt(2)
        @test round(MyHalfInt(5/2), RoundNearest) === MyHalfInt(2)
        @test round(MyHalfInt(5/2), RoundNearestTiesAway) === MyHalfInt(3)
        @test round(MyHalfInt(5/2), RoundNearestTiesUp) === MyHalfInt(3)
        @test round(MyHalfInt(5/2), RoundToZero) === MyHalfInt(2)
        @test round(MyHalfInt(5/2), RoundDown) === MyHalfInt(2)
        @test round(MyHalfInt(5/2), RoundUp) === MyHalfInt(3)
        @test round(Int, MyHalfInt(5/2)) === 2
        @test round(Int, MyHalfInt(5/2), RoundNearest) === 2
        @test round(Int, MyHalfInt(5/2), RoundNearestTiesAway) === 3
        @test round(Int, MyHalfInt(5/2), RoundNearestTiesUp) === 3
        @test round(Int, MyHalfInt(5/2), RoundToZero) === 2
        @test round(Int, MyHalfInt(5/2), RoundDown) === 2
        @test round(Int, MyHalfInt(5/2), RoundUp) === 3
        @test ceil(MyHalfInt(7/2)) === MyHalfInt(4)
        @test floor(MyHalfInt(7/2)) === MyHalfInt(3)
        @test trunc(MyHalfInt(7/2)) === MyHalfInt(3)
        @test ceil(Int, MyHalfInt(7/2)) === 4
        @test floor(Int, MyHalfInt(7/2)) === 3
        @test trunc(Int, MyHalfInt(7/2)) === 3
    end
end
