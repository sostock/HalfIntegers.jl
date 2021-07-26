using HalfIntegers, Test

inttypes  = (:Int8, :Int16, :Int32, :Int64, :Int128)
uinttypes = (:UInt8, :UInt16, :UInt32, :UInt64, :UInt128)
halfinttypes  = (:HalfInt8, :HalfInt16, :HalfInt32, :HalfInt64, :HalfInt128)
halfuinttypes = (:HalfUInt8, :HalfUInt16, :HalfUInt32, :HalfUInt64, :HalfUInt128)

==ₜ(x, y) = x === y
==ₜ(x::T, y::T) where T<:Union{BigInt,BigFloat,BigHalfInt,Rational{BigInt},Complex{BigInt},Complex{BigFloat},Complex{BigHalfInt},Complex{Rational{BigInt}}} = x == y
==ₜ(x::AbstractArray, y::AbstractArray) = (x == y) && (typeof(x) == typeof(y))

@test isempty(Test.detect_ambiguities(HalfIntegers, Base, Core))

@testset "Aliases" begin
    @test HalfInt === Half{Int}
    @test HalfInt8 === Half{Int8}
    @test HalfInt16 === Half{Int16}
    @test HalfInt32 === Half{Int32}
    @test HalfInt64 === Half{Int64}
    @test HalfInt128 === Half{Int128}
    @test BigHalfInt === Half{BigInt}
    @test HalfUInt === Half{UInt}
    @test HalfUInt8 === Half{UInt8}
    @test HalfUInt16 === Half{UInt16}
    @test HalfUInt32 === Half{UInt32}
    @test HalfUInt64 === Half{UInt64}
    @test HalfUInt128 === Half{UInt128}
end

@testset "Constructors" begin
    for T in (halfinttypes..., halfuinttypes..., :BigHalfInt)
        @eval @test $T <: HalfInteger
        @eval @test $T(2.5) isa $T
        @eval @test $T(3) isa $T
        @eval @test $T(true) isa $T
        @eval @test $T(31//2) isa $T
        @eval @test $T(1.5 + 0.0im) isa $T
        @eval @test $T(2 + 0im) isa $T
        @eval @test $T(HalfInt(5/2)) isa $T
        @eval @test $T($T(5/2)) isa $T
        @eval @test_throws InexactError $T(2.6)
        @eval @test_throws InexactError $T(nextfloat(2.5))
        @eval @test_throws InexactError $T(7//3)
        @eval @test_throws InexactError $T(2im)
        @eval @test_throws InexactError $T(2.0im)
        @eval @test_throws InexactError $T(big(2im))
        @eval @test_throws InexactError $T(big(2.0im))
        @eval @test_throws InexactError $T(π)
        @eval @test HalfInteger($T(5/2)) isa $T
        @eval @test HalfInteger($T(5/2)) ==ₜ $T(5/2)
        @eval @test big($T) === BigHalfInt
    end
    for T in halfuinttypes
        @eval @test_throws InexactError $T(-0.5)
        @eval @test_throws InexactError $T(-2)
        @eval @test_throws InexactError $T(-31//2)
        @eval @test_throws InexactError $T(-1+0im)
        @eval @test_throws InexactError $T(HalfInt(-2))
    end
    @test HalfInt32(HalfInt64(-11/2)) === HalfInt32(-11/2)
    @test HalfUInt8(BigHalfInt(3/2)) === HalfUInt8(3/2)
    @test HalfInteger(2.5) isa HalfInteger
    @test HalfInteger(1.5 + 0.0im) isa HalfInteger
    @test HalfInteger(2 + 0im) isa HalfInteger
    for T in (inttypes..., uinttypes..., :BigInt)
        @eval @test HalfInteger($T(3)) ==ₜ Half{$T}(3)
        @eval @test HalfInteger($T(3) + $T(0)im) ==ₜ Half{$T}(3)
        @eval @test_throws InexactError HalfInteger($T(3) + $T(1)im)
        @eval @test HalfInteger($T(31)//$T(2)) ==ₜ Half{$T}(31//2)
        @eval @test HalfInteger($T(31)//$T(2) + $T(0)//$T(1)*im) ==ₜ Half{$T}(31//2)
        @eval @test_throws InexactError HalfInteger($T(31)//$T(2) + $T(1)//$T(1)*im)
    end
    @test HalfInteger(big(2.5)) ==ₜ BigHalfInt(5/2)
    @test HalfInteger(big(2.5 + 0.0im)) ==ₜ BigHalfInt(5/2)
    @test_throws InexactError HalfInteger(2.0im)
    @test_throws InexactError HalfInteger(big(2.0im))
    @test_throws MethodError Half(2)
end

@testset "Conversion" begin
    @testset "big" begin
        for T in (halfinttypes..., halfuinttypes..., :BigHalfInt)
            @eval @test big($T(5/2)) ==ₜ BigHalfInt(5/2)
            @eval @test big(Complex{$T}(5/2 + 3im)) ==ₜ Complex{BigHalfInt}(5/2 + 3im)
        end
    end

    @testset "complex" begin
        for T in (halfinttypes..., halfuinttypes..., :BigHalfInt)
            @eval @test complex($T(5/2)) ==ₜ Complex{$T}(5/2)
            @eval @test complex(Complex{$T}(5/2 + 3im)) ==ₜ Complex{$T}(5/2 + 3im)
        end
    end

    @testset "float" begin
        for T in (halfinttypes..., halfuinttypes...)
            @eval @test float($T) === Float64
            @eval @test float($T(3/2)) === 1.5
            @eval @test float(Complex{$T}) === Complex{Float64}
            @eval @test float(Complex{$T}(3/2 + 5im)) === 1.5 + 5.0im
        end
        @test float(BigHalfInt) === BigFloat
        @test float(BigHalfInt(-5/2)) ==ₜ BigFloat(-2.5)
        @test float(Complex{BigHalfInt}) === Complex{BigFloat}
        @test float(Complex{BigHalfInt}(-5/2 + 3im)) ==ₜ Complex{BigFloat}(-2.5 + 3.0im)
    end

    @testset "Concrete types" begin
        for T in (halfinttypes..., halfuinttypes..., :BigHalfInt)
            # AbstractFloat
            for F in (:Float16, :Float32, :Float64, :BigFloat)
                @eval @test $F($T(13/2)) ==ₜ $F(6.5)
                @eval @test Complex{$F}($T(13/2)) ==ₜ Complex{$F}(6.5)
            end
            for I in (inttypes..., uinttypes..., :BigInt)
                # Integer
                @eval @test $I($T(2)) ==ₜ $I(2)
                @eval @test_throws InexactError $I($T(1/2))
                # Rational
                @eval @test Rational{$I}($T(7/2)) ==ₜ Rational{$I}(7//2)
                @eval @test Rational{$I}($T(3)) ==ₜ Rational{$I}(3//1)
                # Complex
                @eval @test Complex{$I}($T(5)) ==ₜ Complex{$I}(5)
                @eval @test Complex{Rational{$I}}($T(5)) ==ₜ Complex{Rational{$I}}(5)
            end
            # Bool
            @eval @test Bool($T(1)) === true
            @eval @test Bool($T(0)) === false
            @eval @test_throws InexactError Bool($T(1/2))
            @eval @test_throws InexactError Bool($T(2))
            # Complex
            @eval @test Complex($T(3/2)) ==ₜ Complex{$T}(3/2)
            for H in (halfinttypes..., :BigHalfInt)
                @eval @test Complex{$H}($T(3/2)) ==ₜ Complex{$H}($H(3/2))
            end
        end
        for T in (halfinttypes..., :BigHalfInt)
            for S in (inttypes..., :BigInt)
                # Integer
                @eval @test $S($T(-2)) ==ₜ $S(-2)
                # Rational
                @eval @test Rational{$S}($T(-11/2)) ==ₜ Rational{$S}(-11//2)
            end
            for U in (uinttypes..., :Bool)
                # Integer
                @eval @test_throws InexactError $U($T(-1))
                # Rational
                @eval @test_throws InexactError Rational{$U}($T(-1))
            end
        end
        # Rational
        for T in (inttypes..., uinttypes..., :BigInt)
            @eval @test Rational(Half{$T}(11/2)) ==ₜ Rational{$T}(11//2)
            @eval @test Rational(Half{$T}(5)) ==ₜ Rational{$T}(5//1)
        end
    end

    @testset "Abstract types" begin
        for T in (inttypes..., uinttypes...)
            @eval @test AbstractFloat(Half{$T}(3/2)) === 1.5
            @eval @test Integer(Half{$T}(3)) === $T(3)
            @eval @test_throws InexactError Integer(Half{$T}(3/2))
            @eval @test Signed(Half{$T}(3)) === Signed($T(3))
            @eval @test_throws InexactError Signed(Half{$T}(3/2))
            @eval @test Unsigned(Half{$T}(3)) === Unsigned($T(3))
            @eval @test_throws InexactError Unsigned(Half{$T}(3/2))
        end
        for T in halfinttypes
            @eval @test_throws InexactError Unsigned($T(-3))
        end
        @test AbstractFloat(BigHalfInt(5/2)) ==ₜ BigFloat(2.5)
        @test Integer(BigHalfInt(3)) ==ₜ BigInt(3)
        @test_throws InexactError Integer(BigHalfInt(3/2))
        @test Signed(BigHalfInt(3)) ==ₜ BigInt(3)
        @test_throws InexactError Signed(BigHalfInt(3/2))
    end
end

@testset "half" begin
    @testset "Real" begin
        for T in (inttypes..., uinttypes..., :BigInt)
            @eval @test half($T(5)) ==ₜ Half{$T}(5/2)
        end
        @test half(Float16(5)) === HalfInt(5/2)
        @test half(Float32(5)) === HalfInt(5/2)
        @test half(Float64(5)) === HalfInt(5/2)
        @test half(BigFloat(5)) ==ₜ BigHalfInt(5/2)
        @test half(5//1) === HalfInt(5/2)
        @test half(UInt8(5)//UInt8(1)) === HalfUInt8(5/2)
        @test half(big(5//1)) ==ₜ BigHalfInt(5/2)
        @test_throws InexactError half(5.1)
        @test_throws InexactError half(big(5.1))
        @test_throws InexactError half(5//2)
        @test_throws InexactError half(big(5//2))
        for T in (halfinttypes..., halfuinttypes..., :BigHalfInt)
            for S in (:Int, :UInt8, :BigInt, :Float64, :BigFloat, :(Rational{Int}), :(Rational{BigInt}),
                      :(Complex{Int}), :(Complex{BigInt}), :(Complex{Float64}), :(Complex{BigFloat}))
                @eval @test half($T, $S(5)) ==ₜ $T(5/2)
            end
            @eval @test_throws InexactError half($T, 5.1)
            @eval @test_throws InexactError half($T, big(5.1))
            @eval @test_throws InexactError half($T, 5//2)
            @eval @test_throws InexactError half($T, big(5//2))
            @eval @test_throws InexactError half($T, 5+1im)
            @eval @test_throws InexactError half($T, big(5+1im))
            @eval @test_throws InexactError half($T, 5.5+0.0im)
            @eval @test_throws InexactError half($T, big(5.0+0.5im))
        end
    end

    @testset "Complex" begin
        for T in (inttypes..., uinttypes..., :BigInt)
            @eval @test half(Complex{$T}(5, 4)) ==ₜ Complex{Half{$T}}(5/2, 2)
        end
        @test half(Complex{Float16}(5, 4)) === Complex{HalfInt}(5/2, 2)
        @test half(Complex{Float32}(5, 4)) === Complex{HalfInt}(5/2, 2)
        @test half(Complex{Float64}(5, 4)) === Complex{HalfInt}(5/2, 2)
        @test half(Complex{BigFloat}(5, 4)) ==ₜ Complex{BigHalfInt}(5/2, 2)
        @test half(Complex{Rational{Int}}(5, 4)) === Complex{HalfInt}(5/2, 2)
        @test half(Complex{Rational{UInt8}}(5, 4)) === Complex{HalfUInt8}(5/2, 2)
        @test half(Complex{Rational{BigInt}}(5, 4)) ==ₜ Complex{BigHalfInt}(5/2, 2)
        @test_throws InexactError half(Complex{Float64}(5.5, 1.0))
        @test_throws InexactError half(Complex{BigFloat}(5.5, 1.0))
        @test_throws InexactError half(Complex{Rational{Int}}(5//2, 1//2))
        @test_throws InexactError half(Complex{Rational{BigInt}}(5//2, 1//2))

        for T in (halfinttypes..., halfuinttypes..., :BigHalfInt)
            for S in (:Int, :UInt8, :BigInt, :Float64, :BigFloat, :(Rational{Int}), :(Rational{BigInt}))
                @eval @test half(Complex{$T}, $S(5)) ==ₜ Complex{$T}(5/2, 0)
                @eval @test half(Complex{$T}, Complex{$S}(5, 4)) ==ₜ Complex{$T}(5/2, 2)
            end
            @eval @test_throws InexactError half(Complex{$T}, 5.1)
            @eval @test_throws InexactError half(Complex{$T}, big(5.1))
            @eval @test_throws InexactError half(Complex{$T}, 5//2)
            @eval @test_throws InexactError half(Complex{$T}, big(5//2))
            @eval @test_throws InexactError half(Complex{$T}, 5.5+0.0im)
            @eval @test_throws InexactError half(Complex{$T}, big(5.0+0.5im))
        end
    end
end

@testset "twice" begin
    @testset "Real" begin
        for T in (inttypes..., uinttypes...)
            @eval @test_throws OverflowError twice(Rational{$T}(typemax($T),one($T)))
        end
        for T in inttypes
            @eval @test_throws OverflowError twice(Rational{$T}(typemin($T),one($T)))
        end
        for T in (inttypes..., uinttypes..., :BigInt)
            @eval @test @inferred(twice(Half{$T}(2))) ==ₜ $T(4)
            @eval @test twice(Half{$T}(3/2)) ==ₜ $T(3)
            @eval @test @inferred(twice($T(3))) ==ₜ $T(6)
            @eval @test @inferred(twice(Rational{$T}(3,8))) ==ₜ Rational{$T}(3,4)
            @eval @test twice(Rational{$T}(5,2)) ==ₜ Rational{$T}(5,1)
            @eval @test twice(Rational{$T}(7,1)) ==ₜ Rational{$T}(14,1)
            @eval @test twice(Rational{$T}(1,0)) ==ₜ Rational{$T}(1,0)
            @eval @test @inferred(twice($T, HalfInt(3))) ==ₜ $T(6)
            @eval @test @inferred(twice($T, HalfInt(3/2))) ==ₜ $T(3)
            @eval @test @inferred(twice($T, 3)) ==ₜ $T(6)
            @eval @test @inferred(twice($T, Float16(2.5))) ==ₜ $T(5)
            @eval @test @inferred(twice($T, Float32(2.5))) ==ₜ $T(5)
            @eval @test @inferred(twice($T, Float64(2.5))) ==ₜ $T(5)
            @eval @test @inferred(twice($T, BigFloat(2.5))) ==ₜ $T(5)
            @eval @test @inferred(twice($T, 17//2)) ==ₜ $T(17)
            @eval @test @inferred(twice($T, complex(HalfInt(3)))) ==ₜ $T(6)
            @eval @test @inferred(twice($T, complex(HalfInt(3/2)))) ==ₜ $T(3)
            @eval @test @inferred(twice($T, complex(3))) ==ₜ $T(6)
            @eval @test @inferred(twice($T, complex(Float16(2.5)))) ==ₜ $T(5)
            @eval @test @inferred(twice($T, complex(Float32(2.5)))) ==ₜ $T(5)
            @eval @test @inferred(twice($T, complex(Float64(2.5)))) ==ₜ $T(5)
            @eval @test @inferred(twice($T, complex(BigFloat(2.5)))) ==ₜ $T(5)
            @eval @test @inferred(twice($T, complex(17//2))) ==ₜ $T(17)
            @eval @test_throws InexactError twice($T, Float16(2.3))
            @eval @test_throws InexactError twice($T, Float32(2.3))
            @eval @test_throws InexactError twice($T, Float64(2.3))
            @eval @test_throws InexactError twice($T, BigFloat(2.3))
            @eval @test_throws InexactError twice($T, Inf)
            @eval @test_throws InexactError twice($T, -Inf)
            @eval @test_throws InexactError twice($T, NaN)
            @eval @test_throws InexactError twice($T, 1//5)
            @eval @test_throws InexactError twice($T, 1//0)
            @eval @test_throws InexactError twice($T, Complex{HalfInt}(3, 1))
            @eval @test_throws InexactError twice($T, Complex{HalfInt}(0, 3/2))
            @eval @test_throws InexactError twice($T, Complex{Int}(3, 1))
            @eval @test_throws InexactError twice($T, Complex{Float16}(2.0, 0.5))
            @eval @test_throws InexactError twice($T, Complex{Float32}(2.0, 0.5))
            @eval @test_throws InexactError twice($T, Complex{Float64}(2.0, 0.5))
            @eval @test_throws InexactError twice($T, Complex{BigFloat}(2.0, 0.5))
            @eval @test_throws InexactError twice($T, Complex{Rational{Int}}(17//2, 15//2))
        end
        @test twice(Float16(2.3)) === Float16(4.6)
        @test twice(Float32(2.3)) === Float32(4.6)
        @test twice(Float64(2.3)) === Float64(4.6)
        @test twice(BigFloat(2.3)) ==ₜ BigFloat(4.6)
        @test twice(Inf) === Inf
        @test twice(-Inf) === -Inf
        @test twice(NaN) === NaN
    end

    @testset "Complex" begin
        for T in (inttypes..., uinttypes..., :BigInt)
            @eval @test twice(Complex{Half{$T}}(2, 3/2)) ==ₜ Complex{$T}(4, 3)
            @eval @test twice(Complex{$T}(3, 2)) ==ₜ Complex{$T}(6, 4)
            @eval @test twice(Complex{$T}, HalfInt(3)) ==ₜ Complex{$T}(6,0)
            @eval @test twice(Complex{$T}, HalfInt(3/2)) ==ₜ Complex{$T}(3,0)
            @eval @test twice(Complex{$T}, 3) ==ₜ Complex{$T}(6,0)
            @eval @test twice(Complex{$T}, Float16(2.5)) ==ₜ Complex{$T}(5,0)
            @eval @test twice(Complex{$T}, Float32(2.5)) ==ₜ Complex{$T}(5,0)
            @eval @test twice(Complex{$T}, Float64(2.5)) ==ₜ Complex{$T}(5,0)
            @eval @test twice(Complex{$T}, BigFloat(2.5)) ==ₜ Complex{$T}(5,0)
            @eval @test twice(Complex{$T}, 17//2) ==ₜ Complex{$T}(17,0)
            @eval @test twice(Complex{$T}, Complex{HalfInt}(3, 7/2)) ==ₜ Complex{$T}(6,7)
            @eval @test twice(Complex{$T}, Complex{Int}(3,2)) ==ₜ Complex{$T}(6,4)
            @eval @test twice(Complex{$T}, Complex{Float16}(2.5, 1.0)) ==ₜ Complex{$T}(5,2)
            @eval @test twice(Complex{$T}, Complex{Float32}(2.5, 1.0)) ==ₜ Complex{$T}(5,2)
            @eval @test twice(Complex{$T}, Complex{Float64}(2.5, 1.0)) ==ₜ Complex{$T}(5,2)
            @eval @test twice(Complex{$T}, Complex{BigFloat}(2.5, 1.0)) ==ₜ Complex{$T}(5,2)
            @eval @test twice(Complex{$T}, Complex{Rational{Int}}(17//2, 3//1)) ==ₜ Complex{$T}(17,6)
            @eval @test_throws InexactError twice(Complex{$T}, Float16(2.3))
            @eval @test_throws InexactError twice(Complex{$T}, Float32(2.3))
            @eval @test_throws InexactError twice(Complex{$T}, Float64(2.3))
            @eval @test_throws InexactError twice(Complex{$T}, BigFloat(2.3))
            @eval @test_throws InexactError twice(Complex{$T}, 1//5)
            @eval @test_throws InexactError twice(Complex{$T}, Complex{Float16}(2.0, 0.6))
            @eval @test_throws InexactError twice(Complex{$T}, Complex{Float32}(2.0, 0.6))
            @eval @test_throws InexactError twice(Complex{$T}, Complex{Float64}(2.0, 0.6))
            @eval @test_throws InexactError twice(Complex{$T}, Complex{BigFloat}(2.0, 0.6))
            @eval @test_throws InexactError twice(Complex{$T}, Complex{Rational{Int}}(17//2, 15//4))
        end
        @test twice(Complex{Float16}(2.0, 2.3)) === Complex{Float16}(4.0, 4.6)
        @test twice(Complex{Float32}(2.0, 2.3)) === Complex{Float32}(4.0, 4.6)
        @test twice(Complex{Float64}(2.0, 2.3)) === Complex{Float64}(4.0, 4.6)
        @test twice(Complex{BigFloat}(2.0, 2.3)) ==ₜ Complex{BigFloat}(4.0, 4.6)
        @test twice(Complex{Rational{Int}}(2//3, 3//8)) === Complex{Rational{Int}}(4//3, 3//4)
    end
end

@testset "onehalf" begin
    @test onehalf(Number) === onehalf(HalfInt)
    @test onehalf(Complex) === onehalf(Complex{HalfInt})
    for T in (:Real, :HalfInteger, halfinttypes..., halfuinttypes..., :BigHalfInt, :(Half{Integer}),
              :AbstractFloat, :Float16, :Float32, :Float64, :BigFloat,
              :Rational, :(Rational{Int}), :(Rational{UInt8}), :(Rational{BigInt}), :(Rational{Integer}))
        @eval @test onehalf($T) ==ₜ $T(HalfInt(1/2))
        @eval @test onehalf(Complex{$T}) ==ₜ Complex{$T}(HalfInt(1/2), 0)
    end
end

@testset "Properties" begin
    @testset "isfinite" begin
        for T in (halfinttypes..., halfuinttypes..., :BigHalfInt)
            @eval @test isfinite($T(3))
            @eval @test isfinite($T(5/2))
        end
    end

    @testset "ishalfinteger" begin
        for T in (halfinttypes..., halfuinttypes..., :BigHalfInt)
            @eval @test ishalfinteger($T(3))
            @eval @test ishalfinteger($T(5/2))
        end
        @test ishalfinteger(5)
        @test ishalfinteger(big(-5))
        @test ishalfinteger(5//2)
        @test ishalfinteger(-3//2)
        @test !ishalfinteger(4//3)
        @test ishalfinteger(2.0)
        @test ishalfinteger(-7.5)
        @test !ishalfinteger(2.3)
        @test !ishalfinteger(π)
        @test !ishalfinteger(ℯ)
        @test !ishalfinteger(im)
    end

    @testset "isinteger" begin
        for T in (halfinttypes..., :BigHalfInt)
            @eval @test isinteger($T(3))
            @eval @test isinteger($T(-3))
            @eval @test !isinteger($T(5/2))
            @eval @test !isinteger($T(-5/2))
        end
        for T in halfuinttypes
            @eval @test isinteger($T(3))
            @eval @test !isinteger($T(5/2))
        end
    end

    @static if VERSION ≥ v"1.6.0-DEV.999"
        @testset "ispow2" begin
            for T in (halfinttypes..., :BigHalfInt)
                @eval @test ispow2($T(1/2))
                @eval @test ispow2($T(1))
                @eval @test ispow2($T(4))
                @eval @test !ispow2($T(0))
                @eval @test !ispow2($T(3/2))
                @eval @test !ispow2($T(-1/2))
                @eval @test !ispow2($T(-1))
                @eval @test !ispow2($T(-4))
            end
            for T in halfuinttypes
                @eval @test ispow2($T(1/2))
                @eval @test ispow2($T(1))
                @eval @test ispow2($T(4))
                @eval @test !ispow2($T(0))
                @eval @test !ispow2($T(3/2))
            end
        end
    end

    @testset "typemin/typemax" begin
        for T in (inttypes..., uinttypes...)
            @eval @test typemin(Half{$T}) === half(Half{$T}, typemin($T))
            @eval @test typemax(Half{$T}) === half(Half{$T}, typemax($T))
        end
    end

    @testset "one/zero/isone/iszero" begin
        for T in (halfinttypes..., :BigHalfInt)
            @eval @test one($T) ==ₜ $T(1)
            @eval @test zero($T) ==ₜ $T(0)
            @eval @test iszero($T(0))
            @eval @test !iszero($T(1))
            @eval @test !iszero($T(-1))
            @eval @test !iszero($T(1/2))
            @eval @test !iszero($T(-1/2))
            @eval @test isone($T(1))
            @eval @test !isone($T(-1))
            @eval @test !isone($T(0))
            @eval @test !isone($T(1/2))
            @eval @test !isone($T(-1/2))
        end
        for T in halfuinttypes
            @eval @test one($T) === $T(1)
            @eval @test zero($T) === $T(0)
            @eval @test isone($T(1))
            @eval @test !isone($T(0))
            @eval @test !isone($T(1/2))
            @eval @test iszero($T(0))
            @eval @test !iszero($T(1))
            @eval @test !iszero($T(1/2))
        end
    end

    @testset "numerator/denominator" begin
        for T in (inttypes..., uinttypes..., :BigInt)
            @eval @test @inferred(numerator(Half{$T}(7/2))) ==ₜ $T(7)
            @eval @test numerator(Half{$T}(3)) ==ₜ $T(3)
            @eval @test @inferred(denominator(Half{$T}(7/2))) ==ₜ $T(2)
            @eval @test denominator(Half{$T}(3)) ==ₜ $T(1)
        end
    end
end

@testset "Comparison" begin
    @testset "<" begin
        for T in (halfinttypes..., halfuinttypes..., :BigHalfInt)
            for S in (halfinttypes..., halfuinttypes..., :BigHalfInt)
                @eval @test $S(3/2) < $T(5/2)
                @eval @test $S(3/2) < $T(2)
                @eval @test !($S(3/2) < $T(3/2))
                @eval @test !($S(3/2) < $T(1))
            end
            for S in (halfinttypes..., :BigHalfInt)
                @eval @test $S(-3/2) < $T(1/2)
            end
            @eval @test $T(3/2) < 1.6
            @eval @test $T(3/2) < 2
            @eval @test $T(3/2) < big(1.6)
            @eval @test $T(3/2) < big(2)
            @eval @test $T(3/2) < 31//20
            @eval @test $T(3/2) < Inf
            @eval @test $T(3/2) < 1//0
            @eval @test $T(3/2) > -Inf
            @eval @test $T(3/2) > -1//0
            @eval @test !($T(3/2) < 1)
            @eval @test !($T(3/2) < 29//20)
            @eval @test !($T(0) < -0.0)
            @eval @test !($T(0) > -0.0)
        end
        for T in (halfinttypes..., :BigHalfInt)
            for S in (halfinttypes..., :BigHalfInt)
                @eval @test $T(-5/2) < $S(-2)
                @eval @test !($T(-5/2) < $S(-5/2))
                @eval @test !($T(-5/2) < $S(-3))
            end
        end
    end

    @testset "<=" begin
        for T in (halfinttypes..., halfuinttypes..., :BigHalfInt)
            for S in (halfinttypes..., halfuinttypes..., :BigHalfInt)
                @eval @test $S(3/2) <= $T(5/2)
                @eval @test $S(3/2) <= $T(2)
                @eval @test $S(3/2) <= $T(3/2)
                @eval @test !($S(3/2) <= $T(1))
            end
            for S in (halfinttypes..., :BigHalfInt)
                @eval @test $S(-3/2) <= $T(1/2)
            end
            @eval @test $T(3/2) <= 1.6
            @eval @test $T(3/2) <= 2
            @eval @test $T(3/2) <= big(1.6)
            @eval @test $T(3/2) <= big(2)
            @eval @test $T(3/2) <= 31//20
            @eval @test $T(3/2) <= 1.5
            @eval @test $T(3/2) <= big(1.5)
            @eval @test $T(3/2) <= 3//2
            @eval @test $T(3/2) <= Inf
            @eval @test $T(3/2) <= 1//0
            @eval @test $T(3/2) >= -Inf
            @eval @test $T(3/2) >= -1//0
            @eval @test !($T(3/2) <= 1)
            @eval @test !($T(3/2) <= 29//20)
            @eval @test $T(0) <= -0.0
            @eval @test $T(0) >= -0.0
        end
        for T in (halfinttypes..., :BigHalfInt)
            for S in (halfinttypes..., :BigHalfInt)
                @eval @test $T(-5/2) <= $S(-2)
                @eval @test $T(-5/2) <= $S(-5/2)
                @eval @test !($T(-5/2) <= $S(-3))
            end
        end
    end

    @testset "==" begin
        for T in (halfinttypes..., halfuinttypes..., :BigHalfInt)
            for S in (halfinttypes..., halfuinttypes..., :BigHalfInt)
                @eval @test $S(3/2) == $T(3/2)
                @eval @test $S(2) == $T(2)
                @eval @test $S(3/2) != $T(2)
            end
            for S in (halfinttypes..., :BigHalfInt)
                @eval @test $S(-3/2) != $T(3/2)
            end
            @eval @test $T(2) == 2
            @eval @test $T(2) == big(2)
            @eval @test $T(3/2) == 1.5
            @eval @test $T(3/2) == big(1.5)
            @eval @test $T(3/2) != big(1.6)
            @eval @test $T(3/2) == 3//2
            @eval @test $T(3/2) != Inf
            @eval @test $T(3/2) != 1//0
            @eval @test $T(3/2) != -Inf
            @eval @test $T(3/2) != -1//0
            @eval @test $T(3/2) != 29//20
            @eval @test $T(0) == -0.0
        end
        for T in (halfinttypes..., :BigHalfInt)
            for S in (halfinttypes..., :BigHalfInt)
                @eval @test $T(-5/2) != $S(-2)
                @eval @test $T(-5/2) == $S(-5/2)
            end
        end
    end
end

@testset "Arithmetic" begin
    @testset "Addition/subtraction" begin
        for T in (halfinttypes..., :BigHalfInt)
            @eval @test +$T(5/2) ==ₜ $T(5/2)
            @eval @test -$T(5/2) ==ₜ $T(-5/2)
            @eval @test $T(1/2) + $T(2) ==ₜ $T(5/2)
            @eval @test $T(1/2) - $T(2) ==ₜ $T(-3/2)
        end
        for T in halfinttypes
            @eval @test $T(3/2) + (-2) == -1/2
            @eval @test $T(3/2) - (-2) == 7/2
            @eval @test 1.5 + $T(-2) == -1/2
            @eval @test 1.5 - $T(-2) == 7/2
        end
        for T in halfuinttypes
            @eval @test +$T(2) === $T(2)
            @eval @test $T(1/2) + $T(2) === $T(5/2)
            @eval @test $T(5/2) - $T(2) === $T(1/2)
            @eval @test $T(3/2) + (1) == 5/2
            @eval @test $T(3/2) - (1) == 1/2
            @eval @test (3/2) + $T(1) == 5/2
            @eval @test (3/2) - $T(1) == 1/2
        end
        @test BigHalfInt(1/2) + 2 ==ₜ BigHalfInt(5/2)
        @test BigHalfInt(1/2) - 2 ==ₜ BigHalfInt(-3/2)
        @test 0.5 + BigHalfInt(2) ==ₜ BigFloat(2.5)
        @test 0.5 - BigHalfInt(2) ==ₜ BigFloat(-1.5)
        @test HalfInt8(3/2) + HalfInt64(1/2) === HalfInt64(2)
        @test HalfInt8(3/2) - HalfInt64(1/2) === HalfInt64(1)
        @test HalfInt32(5/2) + 3 === HalfInt(11/2)
        @test 2.5 + HalfInt16(3) === 5.5
    end

    @testset "Multiplication" begin
        @test typemax(HalfInt8)*typemax(HalfInt8) === 16_129/4
        for T in (halfinttypes..., halfuinttypes...)
            @eval @test $T(3/2) * $T(5/2) === 3.75
            @eval @test $T(3/2) * $T(2) === 3.0
            @eval @test $T(3/2) * 2 isa HalfInteger
            @eval @test $T(3/2) * 2 == HalfInt(3)
            @eval @test $T(3/2) * BigInt(2) ==ₜ BigHalfInt(3)
            @eval @test $T(3/2) * Float16(2.5) === Float16(3.75)
            @eval @test $T(3/2) * Float32(2.5) === Float32(3.75)
            @eval @test $T(3/2) * Float64(2.5) === Float64(3.75)
            @eval @test $T(3/2) * BigFloat(2.5) ==ₜ BigFloat(3.75)
            @eval @test $T(3/2) * (5//2) isa Rational
            @eval @test $T(3/2) * (5//2) == 15//4
            @eval @test $T(3/2) * Rational{BigInt}(5//2) ==ₜ Rational{BigInt}(15//4)
            @eval @test 2 * $T(3/2) isa HalfInteger
            @eval @test 2 * $T(3/2) == HalfInt(3)
            @eval @test BigInt(2) * $T(3/2) ==ₜ BigHalfInt(3)
            @eval @test Float16(2.5) * $T(3/2) === Float16(3.75)
            @eval @test Float32(2.5) * $T(3/2) === Float32(3.75)
            @eval @test Float64(2.5) * $T(3/2) === Float64(3.75)
            @eval @test BigFloat(2.5) * $T(3/2) ==ₜ BigFloat(3.75)
            @eval @test (5//2) * $T(3/2) isa Rational
            @eval @test (5//2) * $T(3/2) == 15//4
            @eval @test Rational{BigInt}(5//2) * $T(3/2) ==ₜ Rational{BigInt}(15//4)
        end
        @test HalfInt16(3/2) * HalfUInt128(5/2) == 3.75
        @test BigHalfInt(3/2) * BigHalfInt(5/2) ==ₜ BigFloat(3.75)
        @test BigHalfInt(3/2) * BigHalfInt(2) ==ₜ BigFloat(3.0)
        @test BigHalfInt(3/2) * 2 ==ₜ BigHalfInt(3)
        @test BigHalfInt(3/2) * BigInt(2) ==ₜ BigHalfInt(3)
        @test BigHalfInt(3/2) * Float16(2.5) ==ₜ BigFloat(3.75)
        @test BigHalfInt(3/2) * Float32(2.5) ==ₜ BigFloat(3.75)
        @test BigHalfInt(3/2) * Float64(2.5) ==ₜ BigFloat(3.75)
        @test BigHalfInt(3/2) * BigFloat(2.5) ==ₜ BigFloat(3.75)
        @test BigHalfInt(3/2) * (5//2) == Rational{BigInt}(15//4)
        @test 2* BigHalfInt(3/2) ==ₜ BigHalfInt(3)
        @test BigInt(2) * BigHalfInt(3/2) ==ₜ BigHalfInt(3)
        @test Float16(2.5) * BigHalfInt(3/2) ==ₜ BigFloat(3.75)
        @test Float32(2.5) * BigHalfInt(3/2) ==ₜ BigFloat(3.75)
        @test Float64(2.5) * BigHalfInt(3/2) ==ₜ BigFloat(3.75)
        @test BigFloat(2.5) * BigHalfInt(3/2) ==ₜ BigFloat(3.75)
        @test (5//2) * BigHalfInt(3/2) ==ₜ Rational{BigInt}(15//4)
    end

    @testset "Division" begin
        @testset "/" begin
            for T in (halfinttypes..., halfuinttypes...)
                @eval @test $T(3/2) / $T(2) === 0.75
                @eval @test $T(3/2) / 2 === 0.75
                @eval @test $T(3/2) / BigInt(2) ==ₜ BigFloat(0.75)
                @eval @test $T(3/2) / Float16(2.0) === Float16(0.75)
                @eval @test $T(3/2) / Float32(2.0) === Float32(0.75)
                @eval @test $T(3/2) / Float64(2.0) === Float64(0.75)
                @eval @test $T(3/2) / BigFloat(2.0) ==ₜ BigFloat(0.75)
                @eval @test $T(3/2) / (2//3) isa Rational
                @eval @test $T(3/2) / (2//3) == 9//4
                @eval @test 3 / $T(2) === 1.5
                @eval @test BigInt(3) / $T(2) ==ₜ BigFloat(1.5)
                @eval @test Float16(3.0) / $T(2) === Float16(1.5)
                @eval @test Float32(3.0) / $T(2) === Float32(1.5)
                @eval @test Float64(3.0) / $T(2) === Float64(1.5)
                @eval @test BigFloat(3.0) / $T(2) ==ₜ BigFloat(1.5)
                @eval @test (2//3) / $T(5/2) isa Rational
                @eval @test (2//3) / $T(5/2) == 4//15
            end
            @test HalfInt128(3/2) / HalfInt16(3/2) == 1.0
            @test BigHalfInt(3/2) / BigHalfInt(2) ==ₜ BigFloat(0.75)
            @test BigHalfInt(3/2) / 2 ==ₜ BigFloat(0.75)
            @test BigHalfInt(3/2) / BigInt(2) ==ₜ BigFloat(0.75)
            @test BigHalfInt(3/2) / Float16(2.0) ==ₜ BigFloat(0.75)
            @test BigHalfInt(3/2) / Float32(2.0) ==ₜ BigFloat(0.75)
            @test BigHalfInt(3/2) / Float64(2.0) ==ₜ BigFloat(0.75)
            @test BigHalfInt(3/2) / BigFloat(2.0) ==ₜ BigFloat(0.75)
            @test BigHalfInt(3/2) / (4//3) ==ₜ Rational{BigInt}(9//8)
            @test 2 / BigHalfInt(2) ==ₜ BigFloat(1.0)
            @test BigInt(2) / BigHalfInt(2) ==ₜ BigFloat(1.0)
            @test Float16(2.0) / BigHalfInt(2) ==ₜ BigFloat(1.0)
            @test Float32(2.0) / BigHalfInt(2) ==ₜ BigFloat(1.0)
            @test Float64(2.0) / BigHalfInt(2) ==ₜ BigFloat(1.0)
            @test BigFloat(2.0) / BigHalfInt(2) ==ₜ BigFloat(1.0)
            @test (4//3) / BigHalfInt(3/2) ==ₜ Rational{BigInt}(8//9)
        end

        @testset "\\" begin
            for T in (halfinttypes..., halfuinttypes...)
                @eval @test $T(2) \ $T(3/2) === 0.75
                @eval @test 2 \ $T(3/2) === 0.75
                @eval @test BigInt(2) \ $T(3/2) ==ₜ BigFloat(0.75)
                @eval @test Float16(2.0) \ $T(3/2) === Float16(0.75)
                @eval @test Float32(2.0) \ $T(3/2) === Float32(0.75)
                @eval @test Float64(2.0) \ $T(3/2) === Float64(0.75)
                @eval @test BigFloat(2.0) \ $T(3/2) ==ₜ BigFloat(0.75)
                @eval @test (2//3) \ $T(3/2) isa Rational
                @eval @test (2//3) \ $T(3/2) == 9//4
                @eval @test $T(2) \ 3 === 1.5
                @eval @test $T(2) \ BigInt(3) ==ₜ BigFloat(1.5)
                @eval @test $T(2) \ Float16(3.0) === Float16(1.5)
                @eval @test $T(2) \ Float32(3.0) === Float32(1.5)
                @eval @test $T(2) \ Float64(3.0) === Float64(1.5)
                @eval @test $T(2) \ BigFloat(3.0) ==ₜ BigFloat(1.5)
                @eval @test $T(5/2) \ (2//3) isa Rational
                @eval @test $T(5/2) \ (2//3) == 4//15
            end
            @test HalfInt16(3/2) \ HalfInt128(3/2) == 1.0
            @test BigHalfInt(2) \ BigHalfInt(3/2) ==ₜ BigFloat(0.75)
            @test 2 \ BigHalfInt(3/2) ==ₜ BigFloat(0.75)
            @test BigInt(2) \ BigHalfInt(3/2) ==ₜ BigFloat(0.75)
            @test Float16(2.0) \ BigHalfInt(3/2) ==ₜ BigFloat(0.75)
            @test Float32(2.0) \ BigHalfInt(3/2) ==ₜ BigFloat(0.75)
            @test Float64(2.0) \ BigHalfInt(3/2) ==ₜ BigFloat(0.75)
            @test BigFloat(2.0) \ BigHalfInt(3/2) ==ₜ BigFloat(0.75)
            @test (4//3) \ BigHalfInt(3/2) ==ₜ Rational{BigInt}(9//8)
            @test BigHalfInt(2) \ 2 ==ₜ BigFloat(1.0)
            @test BigHalfInt(2) \ BigInt(2) ==ₜ BigFloat(1.0)
            @test BigHalfInt(2) \ Float16(2.0) ==ₜ BigFloat(1.0)
            @test BigHalfInt(2) \ Float32(2.0) ==ₜ BigFloat(1.0)
            @test BigHalfInt(2) \ Float64(2.0) ==ₜ BigFloat(1.0)
            @test BigHalfInt(2) \ BigFloat(2.0) ==ₜ BigFloat(1.0)
            @test BigHalfInt(3/2) \ (4//3) ==ₜ Rational{BigInt}(8//9)
        end

        @testset "//" begin
            for T in (halfinttypes..., halfuinttypes...)
                @eval @test $T(7/2) // $T(5/2) isa Rational
                @eval @test $T(7/2) // $T(5/2) == 7//5
                @eval @test $T(3/2) // 2 isa Rational
                @eval @test $T(3/2) // 2 == 3//4
                @eval @test $T(3/2) // BigInt(2) ==ₜ Rational{BigInt}(3//4)
                @eval @test $T(3/2) // (2//3) isa Rational
                @eval @test $T(3/2) // (2//3) == 9//4
                @eval @test 2 // $T(3/2) isa Rational
                @eval @test 2 // $T(3/2) == 4//3
                @eval @test BigInt(2) // $T(3/2) ==ₜ Rational{BigInt}(4//3)
                @eval @test (2//3) // $T(3/2) isa Rational
                @eval @test (2//3) // $T(3/2) == 4//9
            end
            @test HalfInt128(3/2) // HalfInt16(3/2) == 1//1
            @test BigHalfInt(3/2) // BigHalfInt(2) ==ₜ Rational{BigInt}(3//4)
            @test BigHalfInt(3/2) // 2 ==ₜ Rational{BigInt}(3//4)
            @test BigHalfInt(3/2) // BigInt(2) ==ₜ Rational{BigInt}(3//4)
            @test BigHalfInt(3/2) // (4//3) ==ₜ Rational{BigInt}(9//8)
            @test 2 // BigHalfInt(2) ==ₜ Rational{BigInt}(1//1)
            @test BigInt(2) // BigHalfInt(2) ==ₜ Rational{BigInt}(1//1)
            @test (4//3) // BigHalfInt(3/2) ==ₜ Rational{BigInt}(8//9)

            # Extra tests for ambiguity resolution with Base
            for T in (halfinttypes..., halfuinttypes..., BigHalfInt)
                @eval @test [1]//$T(2) ==ₜ [1//$T(2)]
                @eval @test Complex(2,0)//$T(2) ==ₜ Complex(2//$T(2),0//1)
                @eval @test $T(2)//Complex(2,0) ==ₜ Complex($T(2)//2,0//1)
            end
        end

        @testset "div/rem/mod" begin
            for f in (:div, :fld, :cld, :rem, :mod, :fld1, :mod1)
                for T in (halfinttypes..., halfuinttypes..., :BigHalfInt)
                    @eval @test @inferred($f($T(7/2), $T(3/2))) == $f(7//2, 3//2)
                    @eval @test @inferred($f($T(7/2), $T(1/2))) == $f(7//2, 1//2)
                    @eval @test @inferred($f($T(9/2), 3)) == $f(9//2, 3)
                    @eval @test @inferred($f($T(7/2), big(-2))) == $f(7//2, -2)
                    @eval @test @inferred($f(4, $T(3/2))) == $f(4, 3//2)
                    @eval @test @inferred($f(big(-7), $T(5/2))) == $f(-7, 5//2)
                end
                @eval @test @inferred($f(HalfInt32(7/2), HalfInt128(3/2))) == $f(7//2, 3//2)
                @eval @test @inferred($f(HalfInt8(7/2), HalfInt64(1/2))) == $f(7//2, 1//2)
                @eval @test @inferred($f(HalfInt16(9/2), HalfInt32(3))) == $f(9//2, 3)
                @eval @test @inferred($f(HalfInt64(7/2), HalfInt128(-2))) == $f(7//2, -2)
                @eval @test @inferred($f(HalfInt16(4), HalfInt8(3/2))) == $f(4, 3//2)
                @eval @test @inferred($f(HalfInt64(-7), HalfInt32(5/2))) == $f(-7, 5//2)
            end
            for f in (:div, :fld, :cld, :fld1)
                @eval @test @inferred($f(BigHalfInt(7/2), BigHalfInt(3/2))) isa BigInt
                @eval @test @inferred($f(BigHalfInt(9/2), 3)) isa BigInt
                @eval @test @inferred($f(BigHalfInt(9/2), big(3))) isa BigInt
                @eval @test @inferred($f(HalfInt(9/2), big(3))) isa BigInt
                @eval @test @inferred($f(big(4), BigHalfInt(3/2))) isa BigInt
                @eval @test @inferred($f(big(4), HalfInt(3/2))) isa BigInt
            end
            for f in (:rem, :mod, :mod1)
                @eval @test @inferred($f(BigHalfInt(7/2), BigHalfInt(3/2))) isa BigHalfInt
                @eval @test @inferred($f(BigHalfInt(9/2), 3)) isa BigHalfInt
                @eval @test @inferred($f(BigHalfInt(9/2), big(3))) isa BigHalfInt
                @eval @test @inferred($f(HalfInt(9/2), big(3))) isa BigHalfInt
                @eval @test @inferred($f(big(4), BigHalfInt(3/2))) isa BigHalfInt
                @eval @test @inferred($f(big(4), HalfInt(3/2))) isa BigHalfInt
            end
        end
        for r in (:RoundToZero, :RoundUp, :RoundDown)
            for T in (halfinttypes..., halfuinttypes..., :BigHalfInt)
                if T in halfuinttypes && r == :RoundUp
                    # cf. https://github.com/JuliaLang/julia/issues/34325
                    @eval @test_skip @inferred(rem($T(7/2), $T(3/2), $r)) == rem(7//2, 3//2, $r)
                    @eval @test_skip @inferred(rem($T(7/2), $T(1/2), $r)) == rem(7//2, 1//2, $r)
                    @eval @test_skip @inferred(rem($T(9/2), 3, $r)) == rem(9//2, 3, $r)
                    @eval @test_skip @inferred(rem($T(7/2), big(-2), $r)) == rem(7//2, -2, $r)
                    @eval @test_skip @inferred(rem(4, $T(3/2), $r)) == rem(4, 3//2, $r)
                    @eval @test_skip @inferred(rem(big(-7), $T(5/2), $r)) == rem(-7, 5//2, $r)
                else
                    @eval @test @inferred(rem($T(7/2), $T(3/2), $r)) == rem(7//2, 3//2, $r)
                    @eval @test @inferred(rem($T(7/2), $T(1/2), $r)) == rem(7//2, 1//2, $r)
                    @eval @test @inferred(rem($T(9/2), 3, $r)) == rem(9//2, 3, $r)
                    @eval @test @inferred(rem($T(7/2), big(-2), $r)) == rem(7//2, -2, $r)
                    @eval @test @inferred(rem(4, $T(3/2), $r)) == rem(4, 3//2, $r)
                    @eval @test @inferred(rem(big(-7), $T(5/2), $r)) == rem(-7, 5//2, $r)
                end
            end
            @eval @test @inferred(rem(HalfInt32(7/2), HalfInt128(3/2), $r)) == rem(7//2, 3//2, $r)
            @eval @test @inferred(rem(HalfInt8(7/2), HalfInt64(1/2), $r)) == rem(7//2, 1//2, $r)
            @eval @test @inferred(rem(HalfInt16(9/2), HalfInt32(3), $r)) == rem(9//2, 3, $r)
            @eval @test @inferred(rem(HalfInt64(7/2), HalfInt128(-2), $r)) == rem(7//2, -2, $r)
            @eval @test @inferred(rem(HalfInt16(4), HalfInt8(3/2), $r)) == rem(4, 3//2, $r)
            @eval @test @inferred(rem(HalfInt64(-7), HalfInt32(5/2), $r)) == rem(-7, 5//2, $r)
            @eval @test @inferred(rem(BigHalfInt(7/2), BigHalfInt(3/2), $r)) isa BigHalfInt
            @eval @test @inferred(rem(BigHalfInt(9/2), 3, $r)) isa BigHalfInt
            @eval @test @inferred(rem(BigHalfInt(9/2), big(3), $r)) isa BigHalfInt
            @eval @test @inferred(rem(HalfInt(9/2), big(3), $r)) isa BigHalfInt
            @eval @test @inferred(rem(big(4), BigHalfInt(3/2), $r)) isa BigHalfInt
            @eval @test @inferred(rem(big(4), HalfInt(3/2), $r)) isa BigHalfInt
        end
        @static if VERSION ≥ v"1.4.0-DEV.208"
            for r in (:RoundNearest, :RoundNearestTiesAway, :RoundNearestTiesUp, :RoundToZero, :RoundUp, :RoundDown)
                for T in (halfinttypes..., halfuinttypes..., :BigHalfInt)
                    @eval @test @inferred(div($T(7/2), $T(3/2), $r)) == div(7//2, 3//2, $r)
                    @eval @test @inferred(div($T(7/2), $T(1/2), $r)) == div(7//2, 1//2, $r)
                    @eval @test @inferred(div($T(9/2), 3, $r)) == div(9//2, 3, $r)
                    @eval @test @inferred(div($T(7/2), big(-2), $r)) == div(7//2, -2, $r)
                    @eval @test @inferred(div(4, $T(3/2), $r)) == div(4, 3//2, $r)
                    @eval @test @inferred(div(big(-7), $T(5/2), $r)) == div(-7, 5//2, $r)
                end
                @eval @test @inferred(div(HalfInt32(7/2), HalfInt128(3/2), $r)) == div(7//2, 3//2, $r)
                @eval @test @inferred(div(HalfInt8(7/2), HalfInt64(1/2), $r)) == div(7//2, 1//2, $r)
                @eval @test @inferred(div(HalfInt16(9/2), HalfInt32(3), $r)) == div(9//2, 3, $r)
                @eval @test @inferred(div(HalfInt64(7/2), HalfInt128(-2), $r)) == div(7//2, -2, $r)
                @eval @test @inferred(div(HalfInt16(4), HalfInt8(3/2), $r)) == div(4, 3//2, $r)
                @eval @test @inferred(div(HalfInt64(-7), HalfInt32(5/2), $r)) == div(-7, 5//2, $r)
                @eval @test @inferred(div(BigHalfInt(7/2), BigHalfInt(3/2), $r)) isa BigInt
                @eval @test @inferred(div(BigHalfInt(9/2), 3, $r)) isa BigInt
                @eval @test @inferred(div(BigHalfInt(9/2), big(3), $r)) isa BigInt
                @eval @test @inferred(div(HalfInt(9/2), big(3), $r)) isa BigInt
                @eval @test @inferred(div(big(4), BigHalfInt(3/2), $r)) isa BigInt
                @eval @test @inferred(div(big(4), HalfInt(3/2), $r)) isa BigInt
            end
            for r in (:RoundToZero, :RoundUp, :RoundDown)
                for T in (halfinttypes..., halfuinttypes..., :BigHalfInt)
                    if T in halfuinttypes && r == :RoundUp
                        # cf. https://github.com/JuliaLang/julia/issues/34325
                        @eval @test_skip @inferred(divrem($T(7/2), $T(3/2), $r)) == divrem(7//2, 3//2, $r)
                        @eval @test_skip @inferred(divrem($T(7/2), $T(1/2), $r)) == divrem(7//2, 1//2, $r)
                        @eval @test_skip @inferred(divrem($T(9/2), 3, $r)) == divrem(9//2, 3, $r)
                        @eval @test_skip @inferred(divrem($T(7/2), big(-2), $r)) == divrem(7//2, -2, $r)
                        @eval @test_skip @inferred(divrem(4, $T(3/2), $r)) == divrem(4, 3//2, $r)
                        @eval @test_skip @inferred(divrem(big(-7), $T(5/2), $r)) == divrem(-7, 5//2, $r)
                    else
                        @eval @test @inferred(divrem($T(7/2), $T(3/2), $r)) == divrem(7//2, 3//2, $r)
                        @eval @test @inferred(divrem($T(7/2), $T(1/2), $r)) == divrem(7//2, 1//2, $r)
                        @eval @test @inferred(divrem($T(9/2), 3, $r)) == divrem(9//2, 3, $r)
                        @eval @test @inferred(divrem($T(7/2), big(-2), $r)) == divrem(7//2, -2, $r)
                        @eval @test @inferred(divrem(4, $T(3/2), $r)) == divrem(4, 3//2, $r)
                        @eval @test @inferred(divrem(big(-7), $T(5/2), $r)) == divrem(-7, 5//2, $r)
                    end
                end
                @eval @test @inferred(divrem(HalfInt32(7/2), HalfInt128(3/2), $r)) == divrem(7//2, 3//2, $r)
                @eval @test @inferred(divrem(HalfInt8(7/2), HalfInt64(1/2), $r)) == divrem(7//2, 1//2, $r)
                @eval @test @inferred(divrem(HalfInt16(9/2), HalfInt32(3), $r)) == divrem(9//2, 3, $r)
                @eval @test @inferred(divrem(HalfInt64(7/2), HalfInt128(-2), $r)) == divrem(7//2, -2, $r)
                @eval @test @inferred(divrem(HalfInt16(4), HalfInt8(3/2), $r)) == divrem(4, 3//2, $r)
                @eval @test @inferred(divrem(HalfInt64(-7), HalfInt32(5/2), $r)) == divrem(-7, 5//2, $r)
                @eval @test @inferred(divrem(BigHalfInt(7/2), BigHalfInt(3/2), $r)) isa Tuple{BigInt,BigHalfInt}
                @eval @test @inferred(divrem(BigHalfInt(9/2), 3, $r)) isa Tuple{BigInt,BigHalfInt}
                @eval @test @inferred(divrem(BigHalfInt(9/2), big(3), $r)) isa Tuple{BigInt,BigHalfInt}
                @eval @test @inferred(divrem(HalfInt(9/2), big(3), $r)) isa Tuple{BigInt,BigHalfInt}
                @eval @test @inferred(divrem(big(4), BigHalfInt(3/2), $r)) isa Tuple{BigInt,BigHalfInt}
                @eval @test @inferred(divrem(big(4), HalfInt(3/2), $r)) isa Tuple{BigInt,BigHalfInt}
            end
        end
        @static if VERSION ≥ v"1.5.0-DEV.471"
            for (f,bigreturntype) in ((:rem, :BigHalfInt), (:divrem, :(Tuple{BigInt,BigHalfInt})))
                for T in (halfinttypes..., :BigHalfInt)
                    @eval @test @inferred($f($T(7/2), $T(3/2), RoundNearest)) == $f(7//2, 3//2, RoundNearest)
                    @eval @test @inferred($f($T(7/2), $T(1/2), RoundNearest)) == $f(7//2, 1//2, RoundNearest)
                    @eval @test @inferred($f($T(9/2), 3, RoundNearest)) == $f(9//2, 3, RoundNearest)
                    @eval @test @inferred($f($T(7/2), big(-2), RoundNearest)) == $f(7//2, -2, RoundNearest)
                    @eval @test @inferred($f(4, $T(3/2), RoundNearest)) == $f(4, 3//2, RoundNearest)
                    @eval @test @inferred($f(big(-7), $T(5/2), RoundNearest)) == $f(-7, 5//2, RoundNearest)
                end
                for T in halfuinttypes
                    # cf. https://github.com/JuliaLang/julia/issues/34325
                    @eval @test_skip @inferred($f($T(7/2), $T(3/2), RoundNearest)) == $f(7//2, 3//2, RoundNearest)
                    @eval @test_skip @inferred($f($T(7/2), $T(1/2), RoundNearest)) == $f(7//2, 1//2, RoundNearest)
                    @eval @test_skip @inferred($f($T(9/2), 3, RoundNearest)) == $f(9//2, 3, RoundNearest)
                    @eval @test_skip @inferred($f($T(7/2), big(-2), RoundNearest)) == $f(7//2, -2, RoundNearest)
                    @eval @test_skip @inferred($f(4, $T(3/2), RoundNearest)) == $f(4, 3//2, RoundNearest)
                    @eval @test_skip @inferred($f(big(-7), $T(5/2), RoundNearest)) == $f(-7, 5//2, RoundNearest)
                end
                @eval @test @inferred($f(HalfInt32(7/2), HalfInt128(3/2), RoundNearest)) == $f(7//2, 3//2, RoundNearest)
                @eval @test @inferred($f(HalfInt8(7/2), HalfInt64(1/2), RoundNearest)) == $f(7//2, 1//2, RoundNearest)
                @eval @test @inferred($f(HalfInt16(9/2), HalfInt32(3), RoundNearest)) == $f(9//2, 3, RoundNearest)
                @eval @test @inferred($f(HalfInt64(7/2), HalfInt128(-2), RoundNearest)) == $f(7//2, -2, RoundNearest)
                @eval @test @inferred($f(HalfInt16(4), HalfInt8(3/2), RoundNearest)) == $f(4, 3//2, RoundNearest)
                @eval @test @inferred($f(HalfInt64(-7), HalfInt32(5/2), RoundNearest)) == $f(-7, 5//2, RoundNearest)
                @eval @test @inferred($f(BigHalfInt(7/2), BigHalfInt(3/2), RoundNearest)) isa $bigreturntype
                @eval @test @inferred($f(BigHalfInt(9/2), 3, RoundNearest)) isa $bigreturntype
                @eval @test @inferred($f(BigHalfInt(9/2), big(3), RoundNearest)) isa $bigreturntype
                @eval @test @inferred($f(HalfInt(9/2), big(3), RoundNearest)) isa $bigreturntype
                @eval @test @inferred($f(big(4), BigHalfInt(3/2), RoundNearest)) isa $bigreturntype
                @eval @test @inferred($f(big(4), HalfInt(3/2), RoundNearest)) isa $bigreturntype
            end
        end
    end

    @testset "Exponentiation" begin
        # Half-integer exponent
        for T in halfinttypes
            @eval @test 2^$T(5/2) ≈ √32
            @eval @test 2^$T(4) ≈ 16
            @eval @test big(2)^$T(5/2) isa BigFloat
            @eval @test big(2)^$T(5/2) ≈ √32
            @eval @test big(2)^$T(4) ≈ 16
            @eval @test 2.0^$T(5/2) ≈ √32
            @eval @test 2.0^$T(-3/2) ≈ 1/√8
            @eval @test 2.0^$T(4) ≈ 16
            @eval @test 2.0^$T(-3) ≈ 1/8
            @eval @test big(2.0)^$T(5/2) isa BigFloat
            @eval @test big(2.0)^$T(5/2) ≈ √32
            @eval @test big(2.0)^$T(-3/2) ≈ 1/√8
            @eval @test big(2.0)^$T(4) ≈ 16
            @eval @test big(2.0)^$T(-3) ≈ 1/8
            @eval @test exp($T(5/2)) ≈ exp(2.5)
            @eval @test exp($T(5/2)*im) ≈ exp(2.5*im)
            @eval @test ℯ^$T(5/2) == exp($T(5/2))
            @eval @test ℯ^($T(5/2)*im) == exp($T(5/2)*im)
        end
        for T in halfuinttypes
            @eval @test 2^$T(5/2) ≈ √32
            @eval @test 2^$T(4) ≈ 16
            @eval @test 2.0^$T(5/2) ≈ √32
            @eval @test 2.0^$T(4) ≈ 16
            @eval @test exp($T(5/2)) ≈ exp(2.5)
            @eval @test exp($T(5/2)*im) ≈ exp(2.5*im)
            @eval @test ℯ^$T(5/2) == exp($T(5/2))
            @eval @test ℯ^($T(5/2)*im) == exp($T(5/2)*im)
        end
        @test 2^BigHalfInt(5/2) isa BigFloat
        @test 2^BigHalfInt(5/2) ≈ √32
        @test 2^BigHalfInt(4) ≈ 16
        @test big(2)^BigHalfInt(5/2) isa BigFloat
        @test big(2)^BigHalfInt(5/2) ≈ √32
        @test big(2)^BigHalfInt(4) ≈ 16
        @test 2.0^BigHalfInt(5/2) isa BigFloat
        @test 2.0^BigHalfInt(5/2) ≈ √32
        @test 2.0^BigHalfInt(-3/2) ≈ 1/√8
        @test 2.0^BigHalfInt(4) ≈ 16
        @test 2.0^BigHalfInt(-3) ≈ 1/8
        @test big(2.0)^BigHalfInt(5/2) isa BigFloat
        @test big(2.0)^BigHalfInt(5/2) ≈ √32
        @test big(2.0)^BigHalfInt(-3/2) ≈ 1/√8
        @test big(2.0)^BigHalfInt(4) ≈ 16
        @test big(2.0)^BigHalfInt(-3) ≈ 1/8
        @test exp(BigHalfInt(5/2)) isa BigFloat
        @test exp(BigHalfInt(5/2)*im) isa Complex{BigFloat}
        @test exp(BigHalfInt(5/2)) ≈ exp(big(2.5))
        @test exp(BigHalfInt(5/2)*im) ≈ exp(big(2.5)*im)
        @test ℯ^BigHalfInt(5/2) ==ₜ exp(BigHalfInt(5/2))
        @test ℯ^(BigHalfInt(5/2)*im) ==ₜ exp(BigHalfInt(5/2)*im)
        # Half-integer base
        for T in halfinttypes
            @eval @test $T(2)^4 ≈ 16
            @eval @test $T(-2)^4 ≈ 16
            @eval @test $T(3/2)^3 ≈ 27/8
            @eval @test $T(-3/2)^3 ≈ -27/8
            @eval @test $T(2)^4.0 ≈ 16
            @eval @test $T(2)^3.0 ≈ 8
            @eval @test $T(-2)^4.0 ≈ 16
            @eval @test $T(-2)^3.0 ≈ -8
            @eval @test $T(3/2)^4.0 ≈ 81/16
            @eval @test $T(3/2)^3.0 ≈ 27/8
            @eval @test $T(-3/2)^4.0 ≈ 81/16
            @eval @test $T(-3/2)^3.0 ≈ -27/8
            @eval @test complex($T(2))^1.5 ≈ √8
            @eval @test complex($T(-2))^1.5 ≈ -√8*im
            @eval @test complex($T(-2))^2.5 ≈ √32*im
        end
        for T in halfuinttypes
            @eval @test $T(2)^4 ≈ 16
            @eval @test $T(3/2)^3 ≈ 27/8
            @eval @test $T(2)^4.0 ≈ 16
            @eval @test $T(3/2)^1.5 ≈ √(27/8)
        end
        @test @inferred(BigHalfInt(2)^4) isa BigFloat
        @test @inferred(BigHalfInt(2)^4.0) isa BigFloat
        @test @inferred(complex(BigHalfInt(2))^4.0) isa Complex{BigFloat}
        @test BigHalfInt(2)^4 ≈ 16
        @test BigHalfInt(-2)^4 ≈ 16
        @test BigHalfInt(3/2)^3 ≈ 27/8
        @test BigHalfInt(-3/2)^3 ≈ -27/8
        @test BigHalfInt(2)^4.0 ≈ 16
        @test BigHalfInt(2)^3.0 ≈ 8
        @test BigHalfInt(-2)^4.0 ≈ 16
        @test BigHalfInt(-2)^3.0 ≈ -8
        @test BigHalfInt(3/2)^4.0 ≈ 81/16
        @test BigHalfInt(3/2)^3.0 ≈ 27/8
        @test BigHalfInt(-3/2)^4.0 ≈ 81/16
        @test BigHalfInt(-3/2)^3.0 ≈ -27/8
        @test complex(BigHalfInt(2))^1.5 ≈ √8
        @test complex(BigHalfInt(-2))^1.5 ≈ -√8*im
        @test complex(BigHalfInt(-2))^2.5 ≈ √32*im
        # Half-integer base and exponent
        for T in halfinttypes
            @eval @test $T(2)^$T(4) ≈ 16
            @eval @test $T(2)^$T(-4) ≈ 1/16
            @eval @test $T(-2)^$T(4) ≈ 16
            @eval @test $T(-2)^$T(-4) ≈ 1/16
            @eval @test $T(3/2)^$T(3) ≈ 27/8
            @eval @test $T(3/2)^$T(-3) ≈ 8/27
            @eval @test $T(-3/2)^$T(3) ≈ -27/8
            @eval @test $T(-3/2)^$T(-3) ≈ -8/27
            @eval @test complex($T(2))^$T(3/2) ≈ √8
            @eval @test complex($T(-2))^$T(3/2) ≈ -√8*im
            @eval @test complex($T(-2))^$T(5/2) ≈ √32*im
        end
        for T in halfuinttypes
            @eval @test $T(2)^$T(4) ≈ 16
            @eval @test $T(3/2)^$T(3) ≈ 27/8
            @eval @test $T(3/2)^$T(3/2) ≈ √(27/8)
        end
        @test @inferred(BigHalfInt(2)^BigHalfInt(4)) isa BigFloat
        @test @inferred(BigHalfInt(2)^HalfInt(4)) isa BigFloat
        @test @inferred(complex(BigHalfInt(2))^BigHalfInt(4)) isa Complex{BigFloat}
        @test @inferred(complex(BigHalfInt(2))^HalfInt(4)) isa Complex{BigFloat}
        @test BigHalfInt(2)^HalfInt(4) ≈ 16
        @test BigHalfInt(2)^HalfInt(3) ≈ 8
        @test BigHalfInt(-2)^HalfInt(4) ≈ 16
        @test BigHalfInt(-2)^HalfInt(3) ≈ -8
        @test BigHalfInt(3/2)^HalfInt(4) ≈ 81/16
        @test BigHalfInt(3/2)^HalfInt(3) ≈ 27/8
        @test BigHalfInt(-3/2)^HalfInt(4) ≈ 81/16
        @test BigHalfInt(-3/2)^HalfInt(3) ≈ -27/8
        @test BigHalfInt(2)^BigHalfInt(4) ≈ 16
        @test BigHalfInt(2)^BigHalfInt(3) ≈ 8
        @test BigHalfInt(-2)^BigHalfInt(4) ≈ 16
        @test BigHalfInt(-2)^BigHalfInt(3) ≈ -8
        @test BigHalfInt(3/2)^BigHalfInt(4) ≈ 81/16
        @test BigHalfInt(3/2)^BigHalfInt(3) ≈ 27/8
        @test BigHalfInt(-3/2)^BigHalfInt(4) ≈ 81/16
        @test BigHalfInt(-3/2)^BigHalfInt(3) ≈ -27/8
        @test complex(BigHalfInt(2))^BigHalfInt(3/2) ≈ √8
        @test complex(BigHalfInt(-2))^BigHalfInt(3/2) ≈ -√8*im
        @test complex(BigHalfInt(-2))^BigHalfInt(5/2) ≈ √32*im
        @test complex(BigHalfInt(2))^HalfInt(3/2) ≈ √8
        @test complex(BigHalfInt(-2))^HalfInt(3/2) ≈ -√8*im
        @test complex(BigHalfInt(-2))^HalfInt(5/2) ≈ √32*im
    end

    @static if VERSION ≥ v"1.4.0-DEV.699"
        @testset "lcm/gcd/gcdx" begin
            @testset "Scalar-argument gcd/lcm" begin
                for T in (halfinttypes..., halfuinttypes..., :BigHalfInt)
                    # One argument
                    @eval @test gcd($T(3/2)) ==ₜ $T(3/2)
                    @eval @test lcm($T(3/2)) ==ₜ $T(3/2)

                    # Two arguments
                    @eval @test lcm($T(1), $T(1/2)) ==ₜ $T(1)
                    @eval @test lcm($T(1), $T(3/2)) ==ₜ $T(3)
                    @eval @test lcm($T(2), $T(3/2)) ==ₜ $T(6)
                    @eval @test lcm($T(3/2), $T(3/2)) ==ₜ $T(3/2)
                    @eval @test lcm($T(5/2), $T(3/2)) ==ₜ $T(15/2)
                    @eval @test lcm(1, $T(1/2)) == 1
                    @eval @test lcm(1//1, $T(3/2)) == 3
                    @eval @test lcm(big(2), $T(3/2)) ==ₜ BigHalfInt(6)
                    @eval @test lcm($T(1/2), 1) == 1
                    @eval @test lcm($T(3/2), 1//1) == 3
                    @eval @test lcm($T(3/2), big(2)) ==ₜ BigHalfInt(6)
                    @eval @test lcm($T(3/2), BigHalfInt(1)) ==ₜ BigHalfInt(3)
                    @eval @test lcm(BigHalfInt(3/2), $T(2)) ==ₜ BigHalfInt(6)
                    @eval @test gcd($T(1), $T(3/2)) ==ₜ $T(1/2)
                    @eval @test gcd($T(2), $T(3/2)) ==ₜ $T(1/2)
                    @eval @test gcd($T(3), $T(3/2)) ==ₜ $T(3/2)
                    @eval @test gcd($T(3), $T(9/2)) ==ₜ $T(3/2)
                    @eval @test gcd($T(3/2), $T(3/2)) ==ₜ $T(3/2)
                    @eval @test gcd(1, $T(3/2)) == 1/2
                    @eval @test gcd(2//1, $T(3/2)) == 1/2
                    @eval @test gcd(big(3), $T(3/2)) ==ₜ BigHalfInt(3/2)
                    @eval @test gcd($T(3/2), 2) == 1/2
                    @eval @test gcd($T(3/2), 3//1) == 3/2
                    @eval @test gcd($T(9/2), big(3)) ==ₜ BigHalfInt(3/2)
                    @eval @test gcd($T(3/2), BigHalfInt(2)) ==ₜ BigHalfInt(1/2)
                    @eval @test gcd(BigHalfInt(3/2), $T(1)) ==ₜ BigHalfInt(1/2)

                    # Three arguments
                    @eval @test lcm($T(2), $T(3/2), $T(2)) ==ₜ $T(6)
                    @eval @test lcm($T(2), $T(3/2), $T(3/2)) ==ₜ $T(6)
                    @eval @test lcm($T(2), $T(3/2), $T(3)) ==ₜ $T(6)
                    @eval @test lcm($T(2), $T(3/2), $T(6)) ==ₜ $T(6)
                    @eval @test lcm($T(3/2), 2, $T(3)) == 6
                    @eval @test lcm($T(3/2), 2, 3//1) == 6
                    @eval @test lcm(2, $T(3/2), $T(3)) == 6
                    @eval @test lcm(2, $T(3/2), 3) == 6
                    @eval @test lcm(2//1, 3, $T(3/2)) == 6
                    @eval @test lcm($T(3/2), $T(3), BigHalfInt(2)) ==ₜ BigHalfInt(6)
                    @eval @test lcm(BigHalfInt(3/2), $T(2), $T(3)) ==ₜ BigHalfInt(6)
                    @eval @test gcd($T(3), $T(9/2), $T(1)) ==ₜ $T(1/2)
                    @eval @test gcd(3, 6, $T(9/2)) == 3/2
                    @eval @test gcd($T(9/2), 3//1, $T(3/2)) == 3/2
                    @eval @test gcd($T(9/2), $T(6), BigHalfInt(3)) ==ₜ BigHalfInt(3/2)
                    @eval @test gcd(BigHalfInt(9/2), $T(3), $T(3/2)) ==ₜ BigHalfInt(3/2)

                    # Four arguments
                    @eval @test lcm($T(2), $T(3/2), $T(2), $T(3)) ==ₜ $T(6)
                    @eval @test lcm($T(2), $T(3/2), $T(6), $T(3/2)) ==ₜ $T(6)
                    @eval @test lcm($T(3/2), 2, 3, $T(1/2)) == 6
                    @eval @test lcm(2//1, 3, $T(6), $T(1/2)) == 6
                    @eval @test lcm(2, 3, 6//1, $T(1/2)) == 6
                    @eval @test lcm($T(3/2), $T(3), $T(1/2), BigHalfInt(2)) ==ₜ BigHalfInt(6)
                    @eval @test lcm(BigHalfInt(3/2), $T(2), $T(3), $T(1/2)) ==ₜ BigHalfInt(6)
                    @eval @test gcd($T(3), $T(9/2), $T(3), $T(9/2)) ==ₜ $T(3/2)
                    @eval @test gcd(3, 6, $T(3/2), $T(9/2)) == 3/2
                    @eval @test gcd(3//1, 6, 2, $T(9/2)) == 1/2
                    @eval @test gcd($T(9/2), big(3), $T(3/2), $T(4)) == 1/2
                    @eval @test gcd($T(9/2), $T(6), $T(5), BigHalfInt(3)) ==ₜ BigHalfInt(1/2)
                    @eval @test gcd(BigHalfInt(9/2), $T(3), $T(3/2), $T(9)) ==ₜ BigHalfInt(3/2)
                end
                for T in (halfinttypes..., :BigHalfInt)
                    @eval @test gcd($T(-5/2), $T(3/2)) ==ₜ $T(1/2)
                end
            end

            @testset "gcd/lcm for arrays" begin
                @test lcm([HalfInt(2), HalfInt(3/2)]) === HalfInt(6)
                @test lcm([HalfInt(2), HalfInt(3/2), HalfInt(3)]) === HalfInt(6)
                @test lcm([HalfInt(3/2), 2, 3//2]) === 6//1
                @test gcd([HalfInt(3), HalfInt(9/2)]) === HalfInt(3/2)
                @test gcd([3, 9//2, HalfInt(1)]) === 1//2
                @test gcd([HalfInt(9/2), HalfInt(6), HalfInt(5), HalfInt(3)]) === HalfInt(1/2)
                @test gcd([5, 2, HalfInt(1/2)]) === HalfInt(1/2)
            end

            @testset "gcdx" begin
                for T in (halfinttypes..., halfuinttypes..., :BigHalfInt)
                    @eval @test ((d,u,v) = gcdx($T(1), $T(3/2)); u*$T(1) + v*$T(3/2) == d == 1/2)
                    @eval @test ((d,u,v) = gcdx($T(2), $T(3/2)); u*$T(2) + v*$T(3/2) == d == 1/2)
                    @eval @test ((d,u,v) = gcdx($T(3), $T(3/2)); u*$T(3) + v*$T(3/2) == d == 3/2)
                    @eval @test ((d,u,v) = gcdx($T(3), $T(9/2)); u*$T(3) + v*$T(9/2) == d == 3/2)
                    @eval @test ((d,u,v) = gcdx($T(3/2), $T(3/2)); u*$T(3/2) + v*$T(3/2) == d == 3/2)
                    @eval @test ((d,u,v) = gcdx(1, $T(3/2)); u*1 + v*$T(3/2) == d == 1/2)
                    @eval @test ((d,u,v) = gcdx(2, $T(3/2)); u*2 + v*$T(3/2) == d == 1/2)
                    @eval @test ((d,u,v) = gcdx($T(3/2), 3); u*$T(3/2) + v*3 == d == 3/2)
                    @eval @test ((d,u,v) = gcdx($T(9/2), 3); u*$T(9/2) + v*3 == d == 3/2)
                end
                for T in (halfinttypes..., :BigHalfInt)
                    @eval @test ((d,u,v) = gcdx($T(-5/2), $T(3/2)); u*$T(-5/2) + v*$T(3/2) == d == 1/2)
                    # For `UInt`s, the Bézout coefficients might be near their typemax, so the
                    # identity cannot be tested for `Rational`s since they check for overflow.
                    # Therefore, `gcdx` with one `HalfInteger` and one `Rational` argument is only
                    # tested for signed integers.
                    @eval @test ((d,u,v) = gcdx(3//2, $T(2)); u*(3//2) + v*$T(2) == d == 1/2)
                    @eval @test ((d,u,v) = gcdx($T(9/2), 3//1); u*$T(9/2) + v*(3//1) == d == 3/2)
                end
                @test gcdx(BigHalfInt(1), BigHalfInt(3/2)) isa Tuple{BigHalfInt,BigInt,BigInt}
                @test gcdx(1, BigHalfInt(3/2)) isa Tuple{BigHalfInt,BigInt,BigInt}
                @test gcdx(BigHalfInt(3/2), 1) isa Tuple{BigHalfInt,BigInt,BigInt}
                @test gcdx(1//1, BigHalfInt(3/2)) isa Tuple{Rational{BigInt},BigInt,BigInt}
                @test gcdx(BigHalfInt(3/2), 1//1) isa Tuple{Rational{BigInt},BigInt,BigInt}
            end
        end
    end

    @testset "abs" begin
        for T in (halfinttypes..., :BigHalfInt)
            @eval @test abs($T(0)) ==ₜ $T(0)
            @eval @test abs($T(1)) ==ₜ $T(1)
            @eval @test abs($T(11/2)) ==ₜ $T(11/2)
            @eval @test abs($T(-1/2)) ==ₜ $T(1/2)
            @eval @test abs($T(-3)) ==ₜ $T(3)
        end
        for T in halfuinttypes
            @eval @test abs($T(0)) === $T(0)
            @eval @test abs($T(1)) === $T(1)
            @eval @test abs($T(11/2)) === $T(11/2)
        end
    end

    @testset "abs2" begin
        for T in halfinttypes
            @eval @test abs2($T(0)) === 0.0
            @eval @test abs2($T(1)) === 1.0
            @eval @test abs2($T(11/2)) === 30.25
            @eval @test abs2($T(-1/2)) === 0.25
            @eval @test abs2($T(-3)) === 9.0
        end
        for T in halfuinttypes
            @eval @test abs2($T(0)) === 0.0
            @eval @test abs2($T(1)) === 1.0
            @eval @test abs2($T(11/2)) === 30.25
        end
        @test abs2(BigHalfInt(0)) ==ₜ BigFloat(0.0)
        @test abs2(BigHalfInt(1)) ==ₜ BigFloat(1.0)
        @test abs2(BigHalfInt(11/2)) ==ₜ BigFloat(30.25)
        @test abs2(BigHalfInt(-1/2)) ==ₜ BigFloat(0.25)
        @test abs2(BigHalfInt(-3)) ==ₜ BigFloat(9.0)
    end

    @testset "sign" begin
        for T in (halfinttypes..., :BigHalfInt)
            @eval @test sign($T(0)) ==ₜ $T(0)
            @eval @test sign($T(1)) ==ₜ $T(1)
            @eval @test sign($T(11/2)) ==ₜ $T(1)
            @eval @test sign($T(-1/2)) ==ₜ $T(-1)
            @eval @test sign($T(-3)) ==ₜ $T(-1)
        end
        for T in halfuinttypes
            @eval @test sign($T(0)) ==ₜ $T(0)
            @eval @test sign($T(1)) ==ₜ $T(1)
            @eval @test sign($T(11/2)) ==ₜ $T(1)
        end
    end

    @testset "signbit" begin
        for T in (halfinttypes..., :BigHalfInt)
            @eval @test signbit($T(0)) === false
            @eval @test signbit($T(1)) === false
            @eval @test signbit($T(11/2)) === false
            @eval @test signbit($T(-1/2)) === true
            @eval @test signbit($T(-3)) === true
        end
        for T in halfuinttypes
            @eval @test signbit($T(0)) === false
            @eval @test signbit($T(1)) === false
            @eval @test signbit($T(11/2)) === false
        end
    end

    @testset "flipsign" begin
        for T in (halfinttypes..., :BigHalfInt)
            @eval @test flipsign($T(0), $T(-3/2)) ==ₜ $T(0)
            @eval @test flipsign($T(0), 4) ==ₜ $T(0)
            @eval @test flipsign($T(11/2), $T(-7/2)) ==ₜ $T(-11/2)
            @eval @test flipsign($T(11/2), 5.0) ==ₜ $T(11/2)
            @eval @test flipsign($T(-1/2), $T(3/2)) ==ₜ $T(-1/2)
            @eval @test flipsign($T(-1/2), -1//3) ==ₜ $T(1/2)
        end
        for T in halfuinttypes
            @eval @test flipsign($T(0), $T(3/2)) ==ₜ $T(0)
            @eval @test flipsign($T(0), -5) ==ₜ $T(0)
            @eval @test flipsign($T(11/2), 1//3) ==ₜ $T(11/2)
            @eval @test flipsign($T(11/2), 0.0) ==ₜ $T(11/2)
        end
    end

    @testset "Complex" begin
        for T in (halfinttypes..., halfuinttypes..., :BigHalfInt)
            @eval @test $T(9/2)*im ==ₜ Complex{$T}(0, 9/2)
            @eval @test big(3) + $T(9/2)*im ==ₜ Complex{BigHalfInt}(3, 9/2)
        end
    end
end

@testset "Promotion" begin
    for T in (halfinttypes..., halfuinttypes...)
        @eval @test promote_type($T, BigInt) === BigHalfInt
        @eval @test promote_type($T, Float16) === Float16
        @eval @test promote_type($T, Float32) === Float32
        @eval @test promote_type($T, Float64) === Float64
        @eval @test promote_type($T, BigFloat) === BigFloat
        @eval @test promote_type($T, Rational{BigInt}) === Rational{BigInt}
        @eval @test promote_type($T, Complex{BigInt}) === Complex{BigHalfInt}
        @eval @test promote_type($T, Complex{Float16}) === Complex{Float16}
        @eval @test promote_type($T, Complex{Float32}) === Complex{Float32}
        @eval @test promote_type($T, Complex{Float64}) === Complex{Float64}
        @eval @test promote_type($T, Complex{BigFloat}) === Complex{BigFloat}
        @eval @test promote_type($T, Complex{Rational{BigInt}}) === Complex{Rational{BigInt}}
        @eval @test promote_type(Complex{$T}, $T) === Complex{$T}
        @eval @test promote_type(Complex{$T}, BigInt) === Complex{BigHalfInt}
        @eval @test promote_type(Complex{$T}, Float16) === Complex{Float16}
        @eval @test promote_type(Complex{$T}, Float32) === Complex{Float32}
        @eval @test promote_type(Complex{$T}, Float64) === Complex{Float64}
        @eval @test promote_type(Complex{$T}, BigFloat) === Complex{BigFloat}
        @eval @test promote_type(Complex{$T}, Rational{BigInt}) === Complex{Rational{BigInt}}
    end
    @test promote_type(HalfInt32, HalfInt16) === HalfInt32
    @test promote_type(HalfUInt, BigHalfInt) === BigHalfInt
    @test promote_type(HalfUInt, HalfInt) === HalfUInt
    @test promote_type(Rational{Int16}, HalfUInt64) === Rational{UInt64}
    @test promote_type(Complex{HalfInt64}, BigHalfInt) === Complex{BigHalfInt}
    @test promote_type(Complex{HalfUInt8}, HalfInt32) === Complex{HalfInt32}
end

@testset "Rounding" begin
    @testset "round" begin
        for T in (inttypes..., uinttypes..., :BigInt)
            @eval @test round(Half{$T}(3))   ==ₜ Half{$T}(3)
            @eval @test round(Half{$T}(5/2)) ==ₜ Half{$T}(2)
            @eval @test round(Half{$T}(7/2)) ==ₜ Half{$T}(4)
            @eval @test round(Half{$T}(3),   RoundNearest) ==ₜ Half{$T}(3)
            @eval @test round(Half{$T}(5/2), RoundNearest) ==ₜ Half{$T}(2)
            @eval @test round(Half{$T}(7/2), RoundNearest) ==ₜ Half{$T}(4)
            @eval @test round(Half{$T}(3),   RoundNearestTiesAway) ==ₜ Half{$T}(3)
            @eval @test round(Half{$T}(5/2), RoundNearestTiesAway) ==ₜ Half{$T}(3)
            @eval @test round(Half{$T}(7/2), RoundNearestTiesAway) ==ₜ Half{$T}(4)
            @eval @test round(Half{$T}(3),   RoundNearestTiesUp) ==ₜ Half{$T}(3)
            @eval @test round(Half{$T}(5/2), RoundNearestTiesUp) ==ₜ Half{$T}(3)
            @eval @test round(Half{$T}(7/2), RoundNearestTiesUp) ==ₜ Half{$T}(4)
            @eval @test round(Half{$T}(3),   RoundToZero) ==ₜ Half{$T}(3)
            @eval @test round(Half{$T}(5/2), RoundToZero) ==ₜ Half{$T}(2)
            @eval @test round(Half{$T}(7/2), RoundToZero) ==ₜ Half{$T}(3)
            @eval @test round(Half{$T}(3),   RoundDown) ==ₜ Half{$T}(3)
            @eval @test round(Half{$T}(5/2), RoundDown) ==ₜ Half{$T}(2)
            @eval @test round(Half{$T}(7/2), RoundDown) ==ₜ Half{$T}(3)
            @eval @test round(Half{$T}(3),   RoundUp) ==ₜ Half{$T}(3)
            @eval @test round(Half{$T}(5/2), RoundUp) ==ₜ Half{$T}(3)
            @eval @test round(Half{$T}(7/2), RoundUp) ==ₜ Half{$T}(4)
            @eval @test round(Integer, Half{$T}(3))   ==ₜ $T(3)
            @eval @test round(Integer, Half{$T}(5/2)) ==ₜ $T(2)
            @eval @test round(Integer, Half{$T}(7/2)) ==ₜ $T(4)
            @eval @test round(Integer, Half{$T}(3),   RoundNearest) ==ₜ $T(3)
            @eval @test round(Integer, Half{$T}(5/2), RoundNearest) ==ₜ $T(2)
            @eval @test round(Integer, Half{$T}(7/2), RoundNearest) ==ₜ $T(4)
            @eval @test round(Integer, Half{$T}(3),   RoundNearestTiesAway) ==ₜ $T(3)
            @eval @test round(Integer, Half{$T}(5/2), RoundNearestTiesAway) ==ₜ $T(3)
            @eval @test round(Integer, Half{$T}(7/2), RoundNearestTiesAway) ==ₜ $T(4)
            @eval @test round(Integer, Half{$T}(3),   RoundNearestTiesUp) ==ₜ $T(3)
            @eval @test round(Integer, Half{$T}(5/2), RoundNearestTiesUp) ==ₜ $T(3)
            @eval @test round(Integer, Half{$T}(7/2), RoundNearestTiesUp) ==ₜ $T(4)
            @eval @test round(Integer, Half{$T}(3),   RoundToZero) ==ₜ $T(3)
            @eval @test round(Integer, Half{$T}(5/2), RoundToZero) ==ₜ $T(2)
            @eval @test round(Integer, Half{$T}(7/2), RoundToZero) ==ₜ $T(3)
            @eval @test round(Integer, Half{$T}(3),   RoundDown) ==ₜ $T(3)
            @eval @test round(Integer, Half{$T}(5/2), RoundDown) ==ₜ $T(2)
            @eval @test round(Integer, Half{$T}(7/2), RoundDown) ==ₜ $T(3)
            @eval @test round(Integer, Half{$T}(3),   RoundUp) ==ₜ $T(3)
            @eval @test round(Integer, Half{$T}(5/2), RoundUp) ==ₜ $T(3)
            @eval @test round(Integer, Half{$T}(7/2), RoundUp) ==ₜ $T(4)
            for S in (inttypes..., uinttypes..., :BigInt)
                @eval @test round($S, Half{$T}(3))   ==ₜ $S(3)
                @eval @test round($S, Half{$T}(5/2)) ==ₜ $S(2)
                @eval @test round($S, Half{$T}(7/2)) ==ₜ $S(4)
                @eval @test round($S, Half{$T}(3),   RoundNearest) ==ₜ $S(3)
                @eval @test round($S, Half{$T}(5/2), RoundNearest) ==ₜ $S(2)
                @eval @test round($S, Half{$T}(7/2), RoundNearest) ==ₜ $S(4)
                @eval @test round($S, Half{$T}(3),   RoundNearestTiesAway) ==ₜ $S(3)
                @eval @test round($S, Half{$T}(5/2), RoundNearestTiesAway) ==ₜ $S(3)
                @eval @test round($S, Half{$T}(7/2), RoundNearestTiesAway) ==ₜ $S(4)
                @eval @test round($S, Half{$T}(3),   RoundNearestTiesUp) ==ₜ $S(3)
                @eval @test round($S, Half{$T}(5/2), RoundNearestTiesUp) ==ₜ $S(3)
                @eval @test round($S, Half{$T}(7/2), RoundNearestTiesUp) ==ₜ $S(4)
                @eval @test round($S, Half{$T}(3),   RoundToZero) ==ₜ $S(3)
                @eval @test round($S, Half{$T}(5/2), RoundToZero) ==ₜ $S(2)
                @eval @test round($S, Half{$T}(7/2), RoundToZero) ==ₜ $S(3)
                @eval @test round($S, Half{$T}(3),   RoundDown) ==ₜ $S(3)
                @eval @test round($S, Half{$T}(5/2), RoundDown) ==ₜ $S(2)
                @eval @test round($S, Half{$T}(7/2), RoundDown) ==ₜ $S(3)
                @eval @test round($S, Half{$T}(3),   RoundUp) ==ₜ $S(3)
                @eval @test round($S, Half{$T}(5/2), RoundUp) ==ₜ $S(3)
                @eval @test round($S, Half{$T}(7/2), RoundUp) ==ₜ $S(4)
            end
        end
        for T in (halfinttypes..., :BigHalfInt)
            @eval @test round($T(-7))   == -7
            @eval @test round($T(-3/2)) == -2
            @eval @test round($T(-9/2)) == -4
            @eval @test round($T(-7),   RoundNearest) == -7
            @eval @test round($T(-3/2), RoundNearest) == -2
            @eval @test round($T(-9/2), RoundNearest) == -4
            @eval @test round($T(-7),   RoundNearestTiesAway) == -7
            @eval @test round($T(-3/2), RoundNearestTiesAway) == -2
            @eval @test round($T(-9/2), RoundNearestTiesAway) == -5
            @eval @test round($T(-7),   RoundNearestTiesUp) == -7
            @eval @test round($T(-3/2), RoundNearestTiesUp) == -1
            @eval @test round($T(-9/2), RoundNearestTiesUp) == -4
            @eval @test round($T(-7),   RoundToZero) == -7
            @eval @test round($T(-3/2), RoundToZero) == -1
            @eval @test round($T(-9/2), RoundToZero) == -4
            @eval @test round($T(-7),   RoundDown) == -7
            @eval @test round($T(-3/2), RoundDown) == -2
            @eval @test round($T(-9/2), RoundDown) == -5
            @eval @test round($T(-7),   RoundUp) == -7
            @eval @test round($T(-3/2), RoundUp) == -1
            @eval @test round($T(-9/2), RoundUp) == -4
            for S in (:Integer, inttypes..., :BigInt)
                @eval @test round($S, $T(-7))   == -7
                @eval @test round($S, $T(-3/2)) == -2
                @eval @test round($S, $T(-9/2)) == -4
                @eval @test round($S, $T(-7),   RoundNearest) == -7
                @eval @test round($S, $T(-3/2), RoundNearest) == -2
                @eval @test round($S, $T(-9/2), RoundNearest) == -4
                @eval @test round($S, $T(-7),   RoundNearestTiesAway) == -7
                @eval @test round($S, $T(-3/2), RoundNearestTiesAway) == -2
                @eval @test round($S, $T(-9/2), RoundNearestTiesAway) == -5
                @eval @test round($S, $T(-7),   RoundNearestTiesUp) == -7
                @eval @test round($S, $T(-3/2), RoundNearestTiesUp) == -1
                @eval @test round($S, $T(-9/2), RoundNearestTiesUp) == -4
                @eval @test round($S, $T(-7),   RoundToZero) == -7
                @eval @test round($S, $T(-3/2), RoundToZero) == -1
                @eval @test round($S, $T(-9/2), RoundToZero) == -4
                @eval @test round($S, $T(-7),   RoundDown) == -7
                @eval @test round($S, $T(-3/2), RoundDown) == -2
                @eval @test round($S, $T(-9/2), RoundDown) == -5
                @eval @test round($S, $T(-7),   RoundUp) == -7
                @eval @test round($S, $T(-3/2), RoundUp) == -1
                @eval @test round($S, $T(-9/2), RoundUp) == -4
            end
            for S in uinttypes
                @eval @test_throws InexactError round($S, $T(-7))
                @eval @test_throws InexactError round($S, $T(-3/2))
                @eval @test_throws InexactError round($S, $T(-9/2))
                @eval @test_throws InexactError round($S, $T(-7),   RoundNearest)
                @eval @test_throws InexactError round($S, $T(-3/2), RoundNearest)
                @eval @test_throws InexactError round($S, $T(-9/2), RoundNearest)
                @eval @test_throws InexactError round($S, $T(-7),   RoundNearestTiesAway)
                @eval @test_throws InexactError round($S, $T(-3/2), RoundNearestTiesAway)
                @eval @test_throws InexactError round($S, $T(-9/2), RoundNearestTiesAway)
                @eval @test_throws InexactError round($S, $T(-7),   RoundNearestTiesUp)
                @eval @test_throws InexactError round($S, $T(-3/2), RoundNearestTiesUp)
                @eval @test_throws InexactError round($S, $T(-9/2), RoundNearestTiesUp)
                @eval @test_throws InexactError round($S, $T(-7),   RoundToZero)
                @eval @test_throws InexactError round($S, $T(-3/2), RoundToZero)
                @eval @test_throws InexactError round($S, $T(-9/2), RoundToZero)
                @eval @test_throws InexactError round($S, $T(-7),   RoundDown)
                @eval @test_throws InexactError round($S, $T(-3/2), RoundDown)
                @eval @test_throws InexactError round($S, $T(-9/2), RoundDown)
                @eval @test_throws InexactError round($S, $T(-7),   RoundUp)
                @eval @test_throws InexactError round($S, $T(-3/2), RoundUp)
                @eval @test_throws InexactError round($S, $T(-9/2), RoundUp)
            end
        end
    end

    @testset "ceil/floor/trunc" begin
        for T in (inttypes..., uinttypes..., :BigInt)
            @eval @test ceil(Half{$T}(3))   ==ₜ Half{$T}(3)
            @eval @test ceil(Half{$T}(5/2)) ==ₜ Half{$T}(3)
            @eval @test ceil(Half{$T}(7/2)) ==ₜ Half{$T}(4)
            @eval @test floor(Half{$T}(3))   ==ₜ Half{$T}(3)
            @eval @test floor(Half{$T}(5/2)) ==ₜ Half{$T}(2)
            @eval @test floor(Half{$T}(7/2)) ==ₜ Half{$T}(3)
            @eval @test trunc(Half{$T}(3))   ==ₜ Half{$T}(3)
            @eval @test trunc(Half{$T}(5/2)) ==ₜ Half{$T}(2)
            @eval @test trunc(Half{$T}(7/2)) ==ₜ Half{$T}(3)
            @eval @test ceil(Integer, Half{$T}(3))   ==ₜ $T(3)
            @eval @test ceil(Integer, Half{$T}(5/2)) ==ₜ $T(3)
            @eval @test ceil(Integer, Half{$T}(7/2)) ==ₜ $T(4)
            @eval @test floor(Integer, Half{$T}(3))   ==ₜ $T(3)
            @eval @test floor(Integer, Half{$T}(5/2)) ==ₜ $T(2)
            @eval @test floor(Integer, Half{$T}(7/2)) ==ₜ $T(3)
            @eval @test trunc(Integer, Half{$T}(3))   ==ₜ $T(3)
            @eval @test trunc(Integer, Half{$T}(5/2)) ==ₜ $T(2)
            @eval @test trunc(Integer, Half{$T}(7/2)) ==ₜ $T(3)
            for S in (inttypes..., uinttypes..., :BigInt)
                @eval @test ceil($S, Half{$T}(3))   ==ₜ $S(3)
                @eval @test ceil($S, Half{$T}(5/2)) ==ₜ $S(3)
                @eval @test ceil($S, Half{$T}(7/2)) ==ₜ $S(4)
                @eval @test floor($S, Half{$T}(3))   ==ₜ $S(3)
                @eval @test floor($S, Half{$T}(5/2)) ==ₜ $S(2)
                @eval @test floor($S, Half{$T}(7/2)) ==ₜ $S(3)
                @eval @test trunc($S, Half{$T}(3))   ==ₜ $S(3)
                @eval @test trunc($S, Half{$T}(5/2)) ==ₜ $S(2)
                @eval @test trunc($S, Half{$T}(7/2)) ==ₜ $S(3)
            end
        end
        for T in (halfinttypes..., :BigHalfInt)
            @eval @test ceil($T(-7))   == -7
            @eval @test ceil($T(-3/2)) == -1
            @eval @test ceil($T(-9/2)) == -4
            @eval @test floor($T(-7))   == -7
            @eval @test floor($T(-3/2)) == -2
            @eval @test floor($T(-9/2)) == -5
            @eval @test trunc($T(-7))   == -7
            @eval @test trunc($T(-3/2)) == -1
            @eval @test trunc($T(-9/2)) == -4
            for S in (:Integer, inttypes..., :BigInt)
                @eval @test ceil($S, $T(-7))   == -7
                @eval @test ceil($S, $T(-3/2)) == -1
                @eval @test ceil($S, $T(-9/2)) == -4
                @eval @test floor($S, $T(-7))   == -7
                @eval @test floor($S, $T(-3/2)) == -2
                @eval @test floor($S, $T(-9/2)) == -5
                @eval @test trunc($S, $T(-7))   == -7
                @eval @test trunc($S, $T(-3/2)) == -1
                @eval @test trunc($S, $T(-9/2)) == -4
            end
            for S in uinttypes
                @eval @test ceil($S, $T(-1/2)) == 0
                @eval @test trunc($S, $T(-1/2)) == 0
                @eval @test_throws InexactError ceil($S, $T(-7))
                @eval @test_throws InexactError ceil($S, $T(-3/2))
                @eval @test_throws InexactError ceil($S, $T(-9/2))
                @eval @test_throws InexactError floor($S, $T(-7))
                @eval @test_throws InexactError floor($S, $T(-3/2))
                @eval @test_throws InexactError floor($S, $T(-9/2))
                @eval @test_throws InexactError trunc($S, $T(-7))
                @eval @test_throws InexactError trunc($S, $T(-3/2))
                @eval @test_throws InexactError trunc($S, $T(-9/2))
            end
        end
    end
end

@testset "Hashing" begin
    for T in (halfinttypes..., halfuinttypes..., :BigHalfInt)
        @eval @test @inferred(hash($T(1))) === hash(1)
        @eval @test @inferred(hash($T(5/2))) === hash(5//2)
    end
    for T in (inttypes..., uinttypes...)
        @eval @test @inferred(hash(half(typemax($T)))) === hash(typemax($T)//2)
        @eval @test @inferred(hash(half(typemin($T)))) === hash(typemin($T)//2)
    end
    @test @inferred(hash(half(-393050634124102232869567034555427371542904833))) ===
        hash(-393050634124102232869567034555427371542904833//2)
end

@testset "widen" begin
    @test widen(HalfInt8) === HalfInt16
    @test widen(HalfInt16) === HalfInt32
    @test widen(HalfInt32) === HalfInt64
    @test widen(HalfInt64) === HalfInt128
    @test widen(HalfInt128) === BigHalfInt
    @test widen(HalfUInt8) === HalfUInt16
    @test widen(HalfUInt16) === HalfUInt32
    @test widen(HalfUInt32) === HalfUInt64
    @test widen(HalfUInt64) === HalfUInt128
    @test widen(HalfUInt128) === BigHalfInt
    @test widen(BigHalfInt) === BigHalfInt
    @test widen(HalfUInt8(5/2)) === HalfUInt16(5/2)
    @test widen(HalfInt64(5/2)) === HalfInt128(5/2)
    @test widen(complex(HalfUInt8(5/2))) === complex(HalfUInt16(5/2))
    @test widen(complex(HalfInt64(5/2))) === complex(HalfInt128(5/2))
end

@testset "Trigonometry" begin
    fs = @static if VERSION ≥ v"1.6.0-DEV.292"
        (:sinpi, :cospi, :sincospi)
    else
        (:sinpi, :cospi)
    end
    for f = fs
        for T = inttypes
            @eval xs = half.(Half{$T}, [0, 1, -2, 4, 5, -5,
                                        typemax($T), typemax($T)-1, typemax($T)-2, typemax($T)-3,
                                        typemin($T), typemin($T)+1, typemin($T)+2, typemin($T)+3])
            @eval @test typeof(@inferred($f(zero(Half{$T})))) === typeof($f(zero(Rational{$T})))
            for x = xs
                @eval @test isequal($f($x), $f(Rational{BigInt}($x)))
            end
        end
        for T = uinttypes
            @eval xs = half.(Half{$T}, [0, 1, 2, 4, 5, 7,
                                        typemax($T), typemax($T)-1, typemax($T)-2, typemax($T)-3])
            @eval @test typeof(@inferred($f(zero(Half{$T})))) === typeof($f(zero(Rational{$T})))
            for x = xs
                @eval @test isequal($f($x), $f(Rational{BigInt}($x)))
            end
        end
        @eval @test typeof(@inferred($f(zero(BigHalfInt)))) === typeof($f(zero(Rational{BigInt})))
        for x = BigHalfInt[0, 1/2, 1, 2, 5/2, 7/2]
            @eval @test isequal($f($x), $f(Rational{BigInt}($x)))
        end
    end
end

@testset "$f" for (f,eq) = ((:sinc,:isequal), (:cosc,:isapprox))
    for T = (inttypes..., :BigInt)
        @eval xs = half.(Half{$T}, -20:20)
        @eval @test typeof(@inferred($f(zero(Half{$T})))) === float($T)
        for x = xs
            @eval @test $eq($f($x), $f(float($x)))
        end
    end
    for T = uinttypes
        @eval xs = half.(Half{$T}, 0:20)
        @eval @test typeof(@inferred($f(zero(Half{$T})))) === float($T)
        for x = xs
            @eval @test $eq($f($x), $f(float($x)))
        end
    end
end

@testset "Parsing" begin
    @testset "Half{<:Signed}" begin
        for T in halfinttypes
            @eval @test tryparse($T, "4") === $T(4)
            @eval @test tryparse($T, "+1/2\n") === $T(1/2)
            @eval @test tryparse($T, " 5 /2") === $T(5/2)
            @eval @test tryparse($T, " -5 / 2") === $T(-5/2)
            @eval @test tryparse($T, " +-3/2") === nothing
            @eval @test tryparse($T, " 5/3") === nothing
            @eval @test tryparse($T, "e/2") === nothing
            @eval @test @inferred(parse($T, "4")) === $T(4)
            @eval @test parse($T, "+1/2\n") === $T(1/2)
            @eval @test parse($T, " 5 /2") === $T(5/2)
            @eval @test parse($T, " -5 / 2") === $T(-5/2)
            @eval @test_throws ArgumentError parse($T, " +-3/2")
            @eval @test_throws ArgumentError parse($T, " 5/3")
            @eval @test_throws ArgumentError parse($T, "e/2")
        end
    end

    @testset "Half{<:Unsigned}" begin
        for T in halfuinttypes
            @eval @test tryparse($T, "4") === $T(4)
            @eval @test tryparse($T, " 1/2\n") === $T(1/2)
            @eval @test tryparse($T, " 5 /2") === $T(5/2)
            @eval @test tryparse($T, " +5 / 2") === nothing
            @eval @test tryparse($T, " -5 / 2") === nothing
            @eval @test tryparse($T, " +-3/2") === nothing
            @eval @test tryparse($T, " 5/3") === nothing
            @eval @test tryparse($T, "e/2") === nothing
            @eval @test @inferred(parse($T, "4")) === $T(4)
            @eval @test parse($T, " 1/2\n") === $T(1/2)
            @eval @test parse($T, " 5 /2") === $T(5/2)
            @eval @test_throws ArgumentError parse($T, " +5 / 2")
            @eval @test_throws ArgumentError parse($T, " -5 / 2")
            @eval @test_throws ArgumentError parse($T, " +-3/2")
            @eval @test_throws ArgumentError parse($T, " 5/3")
            @eval @test_throws ArgumentError parse($T, "e/2")
        end
    end

    @testset "BigHalfInt" begin
        @test tryparse(BigHalfInt, "123456789123456789123456789123456789123456789") ==ₜ
            BigHalfInt(123456789123456789123456789123456789123456789)
        @test tryparse(BigHalfInt, "123456789123456789123456789123456789123456789/2") ==ₜ
            BigHalfInt(123456789123456789123456789123456789123456789//2)
        @eval @test tryparse(BigHalfInt, "4") ==ₜ BigHalfInt(4)
        @eval @test tryparse(BigHalfInt, "+1/2\n") ==ₜ BigHalfInt(1/2)
        @eval @test tryparse(BigHalfInt, " -5 / 2") ==ₜ BigHalfInt(-5/2)
        @eval @test tryparse(BigHalfInt, " +-3/2") === nothing
        @eval @test tryparse(BigHalfInt, " 5/3") === nothing
        @eval @test tryparse(BigHalfInt, "e/2") === nothing
        @test parse(BigHalfInt, "123456789123456789123456789123456789123456789") ==ₜ 
            BigHalfInt(123456789123456789123456789123456789123456789)
        @test parse(BigHalfInt, "123456789123456789123456789123456789123456789/2") ==ₜ 
            BigHalfInt(123456789123456789123456789123456789123456789//2)
        @eval @test parse(BigHalfInt, "4") ==ₜ BigHalfInt(4)
        @eval @test parse(BigHalfInt, "+1/2\n") ==ₜ BigHalfInt(1/2)
        @eval @test parse(BigHalfInt, " -5 / 2") ==ₜ BigHalfInt(-5/2)
        @eval @test_throws ArgumentError parse(BigHalfInt, " +-3/2")
        @eval @test_throws ArgumentError parse(BigHalfInt, " 5/3")
        @eval @test_throws ArgumentError parse(BigHalfInt, "e/2")
    end
end

@testset "string" begin
    for T in (halfinttypes..., :BigHalfInt)
        @eval @test string($T(3/2)) === "3/2"
        @eval @test string($T(5)) === "5"
        @eval @test string($T(-3/2)) === "-3/2"
        @eval @test string($T(-5)) === "-5"
    end
    for T in halfuinttypes
        @eval @test string($T(3/2)) === "3/2"
        @eval @test string($T(5)) === "5"
    end
end

@testset "Missing" begin
    @test twice(missing) === missing
    for T = (halfinttypes..., halfuinttypes..., :BigHalfInt)
        for S = (inttypes..., uinttypes..., :BigInt)
            @eval @test twice(Union{$S,Missing}, $T(5/2)) ==ₜ $S(5)
            @eval @test twice(Union{$S,Missing}, Complex{$T}(5/2)) ==ₜ $S(5)
            @eval @test twice(Union{Complex{$S},Missing}, $T(5/2)) ==ₜ Complex{$S}(5)
            @eval @test twice(Union{Complex{$S},Missing}, Complex{$T}(5/2 + 3/2*im)) ==ₜ Complex{$S}(5 + 3im)
        end
    end
    for T = (inttypes..., uinttypes..., :BigInt)
        @eval @test twice(Union{$T,Missing}, missing) === missing
        @eval @test twice(Union{Complex{$T},Missing}, missing) === missing
        @eval @test_throws MissingException twice($T, missing)
        @eval @test_throws MissingException twice(Complex{$T}, missing)
    end

    @test half(missing) === missing
    for T = (inttypes..., uinttypes..., :BigInt)
        for S = (halfinttypes..., halfuinttypes..., :BigHalfInt)
            @eval @test half(Union{$S,Missing}, $T(5)) ==ₜ $S(5/2)
            @eval @test half(Union{$S,Missing}, Complex{$T}(5)) ==ₜ $S(5/2)
            @eval @test half(Union{Complex{$S},Missing}, $T(5)) ==ₜ Complex{$S}(5/2)
            @eval @test half(Union{Complex{$S},Missing}, Complex{$T}(5 + 3*im)) ==ₜ Complex{$S}(5/2 + 3/2*im)
        end
    end
    for T = (halfinttypes..., halfuinttypes..., :BigHalfInt)
        @eval @test half(Union{$T,Missing}, missing) === missing
        @eval @test half(Union{Complex{$T},Missing}, missing) === missing
        @eval @test_throws MissingException half($T, missing)
        @eval @test_throws MissingException half(Complex{$T}, missing)
    end

    @test onehalf(missing) === onehalf(Missing) === missing

    @test ishalfinteger(missing) === missing
end

include("ranges.jl")
include("checked.jl")
include("customtypes.jl")
