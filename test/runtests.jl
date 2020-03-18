using HalfIntegers, Test

inttypes  = (:Int, :Int8, :Int16, :Int32, :Int64, :Int128)
uinttypes = (:UInt, :UInt8, :UInt16, :UInt32, :UInt64, :UInt128)
halfinttypes  = (:HalfInt, :HalfInt8, :HalfInt16, :HalfInt32, :HalfInt64, :HalfInt128)
halfuinttypes = (:HalfUInt, :HalfUInt8, :HalfUInt16, :HalfUInt32, :HalfUInt64, :HalfUInt128)

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
        @eval @test HalfInteger($T(5/2)) == $T(5/2)
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
    for T in (inttypes..., uinttypes...)
        @eval @test HalfInteger($T(3)) === Half{$T}(3)
        @eval @test HalfInteger($T(3) + $T(0)im) === Half{$T}(3)
        @eval @test_throws InexactError HalfInteger($T(3) + $T(1)im)
        @eval @test HalfInteger($T(31)//$T(2)) === Half{$T}(31//2)
        @eval @test HalfInteger($T(31)//$T(2) + $T(0)//$T(1)*im) === Half{$T}(31//2)
        @eval @test_throws InexactError HalfInteger($T(31)//$T(2) + $T(1)//$T(1)*im)
    end
    @test HalfInteger(big(3)) isa BigHalfInt
    @test HalfInteger(big(3)) == 3
    @test HalfInteger(big(3 + 0im)) isa BigHalfInt
    @test HalfInteger(big(3 + 0im)) == 3
    @test HalfInteger(big(2.5)) isa BigHalfInt
    @test HalfInteger(big(2.5)) == 5/2
    @test HalfInteger(big(2.5 + 0.0im)) isa BigHalfInt
    @test HalfInteger(big(2.5 + 0.0im)) == 5/2
    @test HalfInteger(big(31//2)) isa BigHalfInt
    @test HalfInteger(big(31//2)) == 31/2
    @test HalfInteger(big(31//2 + 0//1*im)) isa BigHalfInt
    @test HalfInteger(big(31//2 + 0//1*im)) == 31/2
    @test_throws InexactError HalfInteger(2.0im)
    @test_throws InexactError HalfInteger(big(2.0im))
    @test_throws MethodError Half(2)
end

@testset "Conversion" begin
    @testset "big" begin
        for T in (halfinttypes..., halfuinttypes..., :BigHalfInt)
            @eval @test big($T(5/2)) isa BigHalfInt
            @eval @test big($T(5/2)) == BigHalfInt(5/2)
        end
    end

    @testset "complex" begin
        for T in (halfinttypes..., halfuinttypes..., :BigHalfInt)
            @eval @test complex($T(5/2)) isa Complex{$T}
            @eval @test complex($T(5/2)) == 5/2
        end
    end

    @testset "float" begin
        for T in (halfinttypes..., halfuinttypes...)
            @eval @test float($T(3/2)) isa AbstractFloat
            @eval @test float($T(3/2)) == 1.5
        end
        @test float(BigHalfInt(-5/2)) isa BigFloat
        @test float(BigHalfInt(-5/2)) == -2.5
    end

    @testset "Concrete types" begin
        for T in (halfinttypes..., halfuinttypes..., :BigHalfInt)
            @eval @test Float16($T(1/2)) === Float16(0.5)
            @eval @test Float32($T(3/2)) === Float32(1.5)
            @eval @test Float64($T(13/2)) === Float64(6.5)
            @eval @test BigFloat($T(3/2)) isa BigFloat
            @eval @test BigFloat($T(3/2)) == BigFloat(1.5)
            # Integer
            @eval @test Bool($T(1)) === true
            @eval @test Bool($T(0)) === false
            @eval @test_throws InexactError Bool($T(1/2))
            @eval @test_throws InexactError Bool($T(2))
            @eval @test UInt($T(1)) === UInt(1)
            @eval @test UInt8($T(1)) === UInt8(1)
            @eval @test UInt16($T(1)) === UInt16(1)
            @eval @test UInt32($T(1)) === UInt32(1)
            @eval @test UInt64($T(1)) === UInt64(1)
            @eval @test UInt128($T(1)) === UInt128(1)
            @eval @test_throws InexactError UInt($T(1/2))
            @eval @test_throws InexactError UInt8($T(1/2))
            @eval @test_throws InexactError UInt16($T(1/2))
            @eval @test_throws InexactError UInt32($T(1/2))
            @eval @test_throws InexactError UInt64($T(1/2))
            @eval @test_throws InexactError UInt128($T(1/2))
            @eval @test Int($T(2)) === Int(2)
            @eval @test Int8($T(2)) === Int8(2)
            @eval @test Int16($T(2)) === Int16(2)
            @eval @test Int32($T(2)) === Int32(2)
            @eval @test Int64($T(2)) === Int64(2)
            @eval @test Int128($T(2)) === Int128(2)
            @eval @test_throws InexactError Int($T(1/2))
            @eval @test_throws InexactError Int8($T(1/2))
            @eval @test_throws InexactError Int16($T(1/2))
            @eval @test_throws InexactError Int32($T(1/2))
            @eval @test_throws InexactError Int64($T(1/2))
            @eval @test_throws InexactError Int128($T(1/2))
            @eval @test BigInt($T(3)) isa BigInt
            @eval @test BigInt($T(3)) == BigInt(3)
            # Rational{T}
            @eval @test Rational{Int32}($T(11/2)) === Int32(11)//Int32(2)
            @eval @test Rational{Int64}($T(5)) === Int64(5)//Int64(1)
            @eval @test Rational{UInt8}($T(7/2)) === UInt8(7)//UInt8(2)
            # Complex{T}
            @eval @test Complex{Int}($T(5)) === Complex(5)
        end
        for T in (halfinttypes..., :BigHalfInt)
            @eval @test Float16($T(1/2)) === Float16(0.5)
            @eval @test Float32($T(3/2)) === Float32(1.5)
            @eval @test Float64($T(13/2)) === Float64(6.5)
            @eval @test BigFloat($T(3/2)) isa BigFloat
            @eval @test BigFloat($T(3/2)) == BigFloat(1.5)
            # Integer
            @eval @test_throws InexactError Bool($T(-1))
            @eval @test_throws InexactError UInt($T(-2))
            @eval @test_throws InexactError UInt8($T(-2))
            @eval @test_throws InexactError UInt16($T(-2))
            @eval @test_throws InexactError UInt32($T(-2))
            @eval @test_throws InexactError UInt64($T(-2))
            @eval @test_throws InexactError UInt128($T(-2))
            @eval @test Int($T(-2)) === Int(-2)
            @eval @test Int8($T(-2)) === Int8(-2)
            @eval @test Int16($T(-2)) === Int16(-2)
            @eval @test Int32($T(-2)) === Int32(-2)
            @eval @test Int64($T(-2)) === Int64(-2)
            @eval @test Int128($T(-2)) === Int128(-2)
            @eval @test BigInt($T(-3)) isa BigInt
            @eval @test BigInt($T(-3)) == BigInt(-3)
            # Rational{T}
            @eval @test Rational{Int32}($T(-11/2)) === Int32(-11)//Int32(2)
            @eval @test Rational{Int64}($T(-5)) === Int64(-5)//Int64(1)
            @eval @test_throws InexactError Rational{UInt64}($T(-5))
            # Complex{T}
            @eval @test Complex{HalfInt}($T(-3/2)) === Complex(HalfInt(-3/2))
        end
        # Rational
        for T in (inttypes..., uinttypes...)
            @eval @test Rational(Half{$T}(11/2)) === $T(11)//$T(2)
        end
        @test Rational(BigHalfInt(-1/2)) isa Rational{BigInt}
        @test Rational(BigHalfInt(-1/2)) == -1//2
        # Complex
        for T in (halfinttypes..., halfuinttypes..., :BigHalfInt)
            @eval @test Complex($T(3/2)) isa Complex{$T}
            @eval @test Complex($T(3/2)) == 3/2
        end
    end

    @testset "Abstract types" begin
        for T in (halfinttypes..., halfuinttypes...)
            # AbstractFloat
            @eval @test AbstractFloat($T(3/2)) isa AbstractFloat
            @eval @test AbstractFloat($T(3/2)) == 1.5
            # Integer
            @eval @test Integer($T(3)) isa Integer
            @eval @test Integer($T(3)) == 3
            @eval @test_throws InexactError Integer($T(3/2))
            @eval @test Signed($T(3)) isa Signed
            @eval @test Signed($T(3)) == 3
            @eval @test_throws InexactError Signed($T(3/2))
            @eval @test Unsigned($T(3)) isa Unsigned
            @eval @test Unsigned($T(3)) == 3
            @eval @test_throws InexactError Unsigned($T(3/2))
            @eval @test_throws InexactError Unsigned($T(-3))
        end
        @test AbstractFloat(BigHalfInt(5/2)) isa BigFloat
        @test AbstractFloat(BigHalfInt(5/2)) == 2.5
        @test Integer(BigHalfInt(3)) isa BigInt
        @test Integer(BigHalfInt(3)) == 3
        @test_throws InexactError Integer(BigHalfInt(3/2))
        @test Signed(BigHalfInt(3)) isa BigInt
        @test Signed(BigHalfInt(3)) == 3
        @test_throws InexactError Signed(BigHalfInt(3/2))
    end
end

@testset "half" begin
    @testset "Real" begin
        @test half(UInt(5)) === HalfUInt(5/2)
        @test half(UInt8(5)) === HalfUInt8(5/2)
        @test half(UInt16(5)) === HalfUInt16(5/2)
        @test half(UInt32(5)) === HalfUInt32(5/2)
        @test half(UInt64(5)) === HalfUInt64(5/2)
        @test half(UInt128(5)) === HalfUInt128(5/2)
        @test half(Int(5)) === HalfInt(5/2)
        @test half(Int8(5)) === HalfInt8(5/2)
        @test half(Int16(5)) === HalfInt16(5/2)
        @test half(Int32(5)) === HalfInt32(5/2)
        @test half(Int64(5)) === HalfInt64(5/2)
        @test half(Int128(5)) === HalfInt128(5/2)
        @test half(BigInt(5)) isa BigHalfInt
        @test half(BigInt(5)) == BigHalfInt(5/2)
        @test half(Float16(5)) == HalfInt(5/2)
        @test half(Float32(5)) == HalfInt(5/2)
        @test half(Float64(5)) == HalfInt(5/2)
        @test half(BigFloat(5)) isa BigHalfInt
        @test half(BigFloat(5)) == BigHalfInt(5/2)
        @test half(5//1) === HalfInt(5/2)
        @test half(UInt8(5)//UInt8(1)) === HalfUInt8(5/2)
        @test half(big(5//1)) isa BigHalfInt
        @test half(big(5//1)) == 5/2
        @test_throws InexactError half(5.1)
        @test_throws InexactError half(big(5.1))
        @test_throws InexactError half(5//2)
        @test_throws InexactError half(big(5//2))
        for T in (halfinttypes..., halfuinttypes...)
            @eval @test half($T, 5) === $T(5/2)
            @eval @test half($T, UInt8(5)) === $T(5/2)
            @eval @test half($T, big(5)) === $T(5/2)
            @eval @test half($T, 5.0) === $T(5/2)
            @eval @test half($T, big(5.0)) === $T(5/2)
            @eval @test half($T, 5//1) === $T(5/2)
            @eval @test half($T, big(5//1)) === $T(5/2)
            @eval @test half($T, 5+0im) === $T(5/2)
            @eval @test half($T, big(5+0im)) === $T(5/2)
            @eval @test half($T, 5.0+0.0im) === $T(5/2)
            @eval @test half($T, big(5.0+0.0im)) === $T(5/2)
            @eval @test_throws InexactError half($T, 5.1)
            @eval @test_throws InexactError half($T, big(5.1))
            @eval @test_throws InexactError half($T, 5//2)
            @eval @test_throws InexactError half($T, big(5//2))
            @eval @test_throws InexactError half($T, 5+1im)
            @eval @test_throws InexactError half($T, big(5+1im))
            @eval @test_throws InexactError half($T, 5.5+0.0im)
            @eval @test_throws InexactError half($T, big(5.0+0.5im))
        end
        @test half(BigHalfInt, 5) isa BigHalfInt
        @test half(BigHalfInt, 5) == 5/2
        @test half(BigHalfInt, UInt8(5)) isa BigHalfInt
        @test half(BigHalfInt, UInt8(5)) == 5/2
        @test half(BigHalfInt, big(5)) isa BigHalfInt
        @test half(BigHalfInt, big(5)) == 5/2
        @test half(BigHalfInt, 5.0) isa BigHalfInt
        @test half(BigHalfInt, 5.0) == 5/2
        @test half(BigHalfInt, big(5.0)) isa BigHalfInt
        @test half(BigHalfInt, big(5.0)) == 5/2
        @test half(BigHalfInt, 5//1) isa BigHalfInt
        @test half(BigHalfInt, 5//1) == 5/2
        @test half(BigHalfInt, big(5//1)) isa BigHalfInt
        @test half(BigHalfInt, big(5//1)) == 5/2
        @test half(BigHalfInt, 5+0im) isa BigHalfInt
        @test half(BigHalfInt, 5+0im) == 5/2
        @test half(BigHalfInt, big(5+0im)) isa BigHalfInt
        @test half(BigHalfInt, big(5+0im)) == 5/2
        @test half(BigHalfInt, 5.0+0.0im) isa BigHalfInt
        @test half(BigHalfInt, 5.0+0.0im) == 5/2
        @test half(BigHalfInt, big(5.0+0.0im)) isa BigHalfInt
        @test half(BigHalfInt, big(5.0+0.0im)) == 5/2
        @test_throws InexactError half(BigHalfInt, 5.1)
        @test_throws InexactError half(BigHalfInt, big(5.1))
        @test_throws InexactError half(BigHalfInt, 5//2)
        @test_throws InexactError half(BigHalfInt, big(5//2))
        @test_throws InexactError half(BigHalfInt, 5+1im)
        @test_throws InexactError half(BigHalfInt, big(5+1im))
        @test_throws InexactError half(BigHalfInt, 5.5+0.0im)
        @test_throws InexactError half(BigHalfInt, big(5.0+0.5im))
    end

    @testset "Complex" begin
        @test half(UInt(5) + UInt(4)*im) === HalfUInt(5/2) + HalfUInt(2)*im
        @test half(UInt8(5) + UInt8(4)*im) === HalfUInt8(5/2) + HalfUInt8(2)*im
        @test half(UInt16(5) + UInt16(4)*im) === HalfUInt16(5/2) + HalfUInt16(2)*im
        @test half(UInt32(5) + UInt32(4)*im) === HalfUInt32(5/2) + HalfUInt32(2)*im
        @test half(UInt64(5) + UInt64(4)*im) === HalfUInt64(5/2) + HalfUInt64(2)*im
        @test half(UInt128(5) + UInt128(4)*im) === HalfUInt128(5/2) + HalfUInt128(2)*im
        @test half(Int(5) + Int(4)*im) === HalfInt(5/2) + HalfInt(2)*im
        @test half(Int8(5) + Int8(4)*im) === HalfInt8(5/2) + HalfInt8(2)*im
        @test half(Int16(5) + Int16(4)*im) === HalfInt16(5/2) + HalfInt16(2)*im
        @test half(Int32(5) + Int32(4)*im) === HalfInt32(5/2) + HalfInt32(2)*im
        @test half(Int64(5) + Int64(4)*im) === HalfInt64(5/2) + HalfInt64(2)*im
        @test half(Int128(5) + Int128(4)*im) === HalfInt128(5/2) + HalfInt128(2)*im
        @test half(BigInt(5) + BigInt(4)*im) isa Complex{BigHalfInt}
        @test half(BigInt(5) + BigInt(4)*im) == BigHalfInt(5/2) + BigHalfInt(2)*im
        @test half(Float16(5) + Float16(4)*im) === HalfInt(5/2) + HalfInt(2)*im
        @test half(Float32(5) + Float32(4)*im) === HalfInt(5/2) + HalfInt(2)*im
        @test half(Float64(5) + Float64(4)*im) === HalfInt(5/2) + HalfInt(2)*im
        @test half(BigFloat(5) + BigFloat(4)*im) isa Complex{BigHalfInt}
        @test half(BigFloat(5) + BigFloat(4)*im) == BigHalfInt(5/2) + BigHalfInt(2)*im
        @test half(5//1 + (4//1)*im) === HalfInt(5/2) + HalfInt(2)*im
        @test half(UInt8(5)//UInt8(1) + (UInt8(4)//UInt8(1))*im) === HalfUInt8(5/2) + HalfUInt8(2)*im
        @test half(big(5//1) + big(4//1)*im) isa Complex{BigHalfInt}
        @test half(big(5//1) + big(4//1)*im) == BigHalfInt(5/2) + BigHalfInt(2)*im
        @test_throws InexactError half(5.5 + 1.0im)
        @test_throws InexactError half(big(5.5 + 1.0im))
        @test_throws InexactError half(5//2 + (1//2)*im)
        @test_throws InexactError half(big(5//2 + (1//2)*im))
        for T in (halfinttypes..., halfuinttypes...)
            @eval @test half(Complex{$T}, 5) === Complex($T(5/2), $T(0))
            @eval @test half(Complex{$T}, UInt8(5)) === Complex($T(5/2), $T(0))
            @eval @test half(Complex{$T}, big(5)) === Complex($T(5/2), $T(0))
            @eval @test half(Complex{$T}, 5.0) === Complex($T(5/2), $T(0))
            @eval @test half(Complex{$T}, big(5.0)) === Complex($T(5/2), $T(0))
            @eval @test half(Complex{$T}, 5//1) === Complex($T(5/2), $T(0))
            @eval @test half(Complex{$T}, big(5//1)) === Complex($T(5/2), $T(0))
            @eval @test half(Complex{$T}, 5+4im) === Complex($T(5/2), $T(2))
            @eval @test half(Complex{$T}, UInt8(5)+UInt8(4)*im) === Complex($T(5/2), $T(2))
            @eval @test half(Complex{$T}, big(5+4im)) === Complex($T(5/2), $T(2))
            @eval @test half(Complex{$T}, 5.0+4.0im) === Complex($T(5/2), $T(2))
            @eval @test half(Complex{$T}, big(5.0+4.0im)) === Complex($T(5/2), $T(2))
            @eval @test half(Complex{$T}, 5//1+(4//1)im) === Complex($T(5/2), $T(2))
            @eval @test half(Complex{$T}, big(5//1+(4//1)*im)) === Complex($T(5/2), $T(2))
            @eval @test_throws InexactError half(Complex{$T}, 5.1)
            @eval @test_throws InexactError half(Complex{$T}, big(5.1))
            @eval @test_throws InexactError half(Complex{$T}, 5//2)
            @eval @test_throws InexactError half(Complex{$T}, big(5//2))
            @eval @test_throws InexactError half(Complex{$T}, 5.5+0.0im)
            @eval @test_throws InexactError half(Complex{$T}, big(5.0+0.5im))
        end
        @test half(Complex{BigHalfInt}, 5) isa Complex{BigHalfInt}
        @test half(Complex{BigHalfInt}, 5) == 5/2
        @test half(Complex{BigHalfInt}, UInt8(5)) isa Complex{BigHalfInt}
        @test half(Complex{BigHalfInt}, UInt8(5)) == 5/2
        @test half(Complex{BigHalfInt}, big(5)) isa Complex{BigHalfInt}
        @test half(Complex{BigHalfInt}, big(5)) == 5/2
        @test half(Complex{BigHalfInt}, 5.0) isa Complex{BigHalfInt}
        @test half(Complex{BigHalfInt}, 5.0) == 5/2
        @test half(Complex{BigHalfInt}, big(5.0)) isa Complex{BigHalfInt}
        @test half(Complex{BigHalfInt}, big(5.0)) == 5/2
        @test half(Complex{BigHalfInt}, 5//1) isa Complex{BigHalfInt}
        @test half(Complex{BigHalfInt}, 5//1) == 5/2
        @test half(Complex{BigHalfInt}, big(5//1)) isa Complex{BigHalfInt}
        @test half(Complex{BigHalfInt}, big(5//1)) == 5/2
        @test half(Complex{BigHalfInt}, 5+4im) isa Complex{BigHalfInt}
        @test half(Complex{BigHalfInt}, 5+4im) == 5/2 + 2im
        @test half(Complex{BigHalfInt}, big(5+4im)) isa Complex{BigHalfInt}
        @test half(Complex{BigHalfInt}, big(5+4im)) == 5/2 + 2im
        @test half(Complex{BigHalfInt}, 5.0+4.0im) isa Complex{BigHalfInt}
        @test half(Complex{BigHalfInt}, 5.0+4.0im) == 5/2 + 2im
        @test half(Complex{BigHalfInt}, big(5.0+4.0im)) isa Complex{BigHalfInt}
        @test half(Complex{BigHalfInt}, big(5.0+4.0im)) == 5/2 + 2im
        @test half(Complex{BigHalfInt}, 5//1+(4//1)*im) isa Complex{BigHalfInt}
        @test half(Complex{BigHalfInt}, 5//1+(4//1)*im) == 5/2 + 2im
        @test half(Complex{BigHalfInt}, big(5//1+(4//1)*im)) isa Complex{BigHalfInt}
        @test half(Complex{BigHalfInt}, big(5//1+(4//1)*im)) == 5/2 + 2im
        @test_throws InexactError half(Complex{BigHalfInt}, 5.1)
        @test_throws InexactError half(Complex{BigHalfInt}, big(5.1))
        @test_throws InexactError half(Complex{BigHalfInt}, 5//2)
        @test_throws InexactError half(Complex{BigHalfInt}, big(5//2))
        @test_throws InexactError half(Complex{BigHalfInt}, 5.5+0.0im)
        @test_throws InexactError half(Complex{BigHalfInt}, big(5.0+0.5im))
    end
end

@testset "twice" begin
    @testset "Real" begin
        for T in (inttypes..., uinttypes...)
            @eval @test twice(Half{$T}(2)) === $T(4)
            @eval @test twice(Half{$T}(3/2)) === $T(3)
            @eval @test twice($T(3)) === $T(6)
            @eval @test twice($T, HalfInt(3)) === $T(6)
            @eval @test twice($T, HalfInt(3/2)) === $T(3)
            @eval @test twice($T, 3) === $T(6)
            @eval @test twice($T, Float16(2.5)) === $T(5)
            @eval @test twice($T, Float32(2.5)) === $T(5)
            @eval @test twice($T, Float64(2.5)) === $T(5)
            @eval @test twice($T, BigFloat(2.5)) === $T(5)
            @eval @test twice($T, 17//2) === $T(17)
            @eval @test twice($T, complex(HalfInt(3))) === $T(6)
            @eval @test twice($T, complex(HalfInt(3/2))) === $T(3)
            @eval @test twice($T, complex(3)) === $T(6)
            @eval @test twice($T, complex(Float16(2.5))) === $T(5)
            @eval @test twice($T, complex(Float32(2.5))) === $T(5)
            @eval @test twice($T, complex(Float64(2.5))) === $T(5)
            @eval @test twice($T, complex(BigFloat(2.5))) === $T(5)
            @eval @test twice($T, complex(17//2)) === $T(17)
            @eval @test_throws InexactError twice($T, Float16(2.3))
            @eval @test_throws InexactError twice($T, Float32(2.3))
            @eval @test_throws InexactError twice($T, Float64(2.3))
            @eval @test_throws InexactError twice($T, BigFloat(2.3))
            @eval @test_throws InexactError twice($T, 1//5)
            @eval @test_throws InexactError twice($T, Complex(HalfInt(3), HalfInt(1)))
            @eval @test_throws InexactError twice($T, Complex(HalfInt(0), HalfInt(3/2)))
            @eval @test_throws InexactError twice($T, Complex(3, 1))
            @eval @test_throws InexactError twice($T, Complex(Float16(2.0), Float16(0.5)))
            @eval @test_throws InexactError twice($T, Complex(Float32(2.0), Float32(0.5)))
            @eval @test_throws InexactError twice($T, Complex(Float64(2.0), Float64(0.5)))
            @eval @test_throws InexactError twice($T, Complex(BigFloat(2.0), BigFloat(0.5)))
            @eval @test_throws InexactError twice($T, Complex(17//2, 15//2))
        end
        @test twice(BigHalfInt(2)) isa BigInt
        @test twice(BigHalfInt(2)) == 4
        @test twice(BigHalfInt(3/2)) == 3
        @test twice(BigInt(3)) isa BigInt
        @test twice(BigInt(3)) == 6
        @test twice(Float16(2.3)) == Float16(4.6)
        @test twice(Float32(2.3)) == Float32(4.6)
        @test twice(Float64(2.3)) == Float64(4.6)
        @test twice(BigFloat(2.3)) isa BigFloat
        @test twice(BigFloat(2.3)) == 4.6
        @test twice(2//3) === 4//3
        @test twice(BigInt, HalfInt(2)) isa BigInt
        @test twice(BigInt, HalfInt(2)) == 4
        @test twice(BigInt, HalfInt(3/2)) == 3
        @test twice(BigInt, 3) isa BigInt
        @test twice(BigInt, 3) == 6
        @test twice(BigInt, Float16(2.5)) isa BigInt
        @test twice(BigInt, Float32(2.5)) isa BigInt
        @test twice(BigInt, Float64(2.5)) isa BigInt
        @test twice(BigInt, BigFloat(2.5)) isa BigInt
        @test twice(BigInt, 17//2) isa BigInt
        @test twice(BigInt, Float16(2.5)) == 5
        @test twice(BigInt, Float32(2.5)) == 5
        @test twice(BigInt, Float64(2.5)) == 5
        @test twice(BigInt, BigFloat(2.5)) == 5
        @test twice(BigInt, 17//2) == 17
        @test twice(BigInt, complex(HalfInt(2))) isa BigInt
        @test twice(BigInt, complex(HalfInt(2))) == 4
        @test twice(BigInt, complex(HalfInt(3/2))) == 3
        @test twice(BigInt, complex(3)) isa BigInt
        @test twice(BigInt, complex(3)) == 6
        @test twice(BigInt, complex(Float16(2.5))) isa BigInt
        @test twice(BigInt, complex(Float32(2.5))) isa BigInt
        @test twice(BigInt, complex(Float64(2.5))) isa BigInt
        @test twice(BigInt, complex(BigFloat(2.5))) isa BigInt
        @test twice(BigInt, complex(17//2)) isa BigInt
        @test twice(BigInt, complex(Float16(2.5))) == 5
        @test twice(BigInt, complex(Float32(2.5))) == 5
        @test twice(BigInt, complex(Float64(2.5))) == 5
        @test twice(BigInt, complex(BigFloat(2.5))) == 5
        @test twice(BigInt, complex(17//2)) == 17
        @test_throws InexactError twice(BigInt, Float16(2.3))
        @test_throws InexactError twice(BigInt, Float32(2.3))
        @test_throws InexactError twice(BigInt, Float64(2.3))
        @test_throws InexactError twice(BigInt, BigFloat(2.3))
        @test_throws InexactError twice(BigInt, 1//5)
        @test_throws InexactError twice(BigInt, Complex(Float16(2.5), Float16(2.0)))
        @test_throws InexactError twice(BigInt, Complex(Float32(2.5), Float32(2.0)))
        @test_throws InexactError twice(BigInt, Complex(Float64(2.5), Float64(2.0)))
        @test_throws InexactError twice(BigInt, Complex(BigFloat(2.5), BigFloat(2.0)))
        @test_throws InexactError twice(BigInt, Complex(17//2, 3//2))
    end

    @testset "Complex" begin
        for T in (inttypes..., uinttypes...)
            @eval @test twice(Complex{Half{$T}}(2, 3/2)) === Complex{$T}(4, 3)
            @eval @test twice(Complex{$T}(3, 2)) === Complex{$T}(6, 4)
            @eval @test twice(Complex{$T}, HalfInt(3)) === Complex{$T}(6,0)
            @eval @test twice(Complex{$T}, HalfInt(3/2)) === Complex{$T}(3,0)
            @eval @test twice(Complex{$T}, 3) === Complex{$T}(6,0)
            @eval @test twice(Complex{$T}, Float16(2.5)) === Complex{$T}(5,0)
            @eval @test twice(Complex{$T}, Float32(2.5)) === Complex{$T}(5,0)
            @eval @test twice(Complex{$T}, Float64(2.5)) === Complex{$T}(5,0)
            @eval @test twice(Complex{$T}, BigFloat(2.5)) === Complex{$T}(5,0)
            @eval @test twice(Complex{$T}, 17//2) === Complex{$T}(17,0)
            @eval @test twice(Complex{$T}, Complex(HalfInt(3), HalfInt(7/2))) === Complex{$T}(6,7)
            @eval @test twice(Complex{$T}, Complex(3,2)) === Complex{$T}(6,4)
            @eval @test twice(Complex{$T}, Complex(Float16(2.5), Float16(1.0))) === Complex{$T}(5,2)
            @eval @test twice(Complex{$T}, Complex(Float32(2.5), Float16(1.0))) === Complex{$T}(5,2)
            @eval @test twice(Complex{$T}, Complex(Float64(2.5), Float16(1.0))) === Complex{$T}(5,2)
            @eval @test twice(Complex{$T}, Complex(BigFloat(2.5), BigFloat(1.0))) === Complex{$T}(5,2)
            @eval @test twice(Complex{$T}, Complex(17//2, 3//1)) === Complex{$T}(17,6)
            @eval @test_throws InexactError twice(Complex{$T}, Float16(2.3))
            @eval @test_throws InexactError twice(Complex{$T}, Float32(2.3))
            @eval @test_throws InexactError twice(Complex{$T}, Float64(2.3))
            @eval @test_throws InexactError twice(Complex{$T}, BigFloat(2.3))
            @eval @test_throws InexactError twice(Complex{$T}, 1//5)
            @eval @test_throws InexactError twice(Complex{$T}, Complex(Float16(2.0), Float16(0.6)))
            @eval @test_throws InexactError twice(Complex{$T}, Complex(Float32(2.0), Float32(0.6)))
            @eval @test_throws InexactError twice(Complex{$T}, Complex(Float64(2.0), Float64(0.6)))
            @eval @test_throws InexactError twice(Complex{$T}, Complex(BigFloat(2.0), BigFloat(0.6)))
            @eval @test_throws InexactError twice(Complex{$T}, Complex(17//2, 15//4))
        end
        @test twice(Complex{BigHalfInt}(2, 3/2)) isa Complex{BigInt}
        @test twice(Complex{BigHalfInt}(2, 3/2)) == Complex(4, 3)
        @test twice(Complex{BigInt}(3, 2)) isa Complex{BigInt}
        @test twice(Complex{BigInt}(3, 2)) == Complex(6, 4)
        @test twice(Complex{Float16}(2.0, 2.3)) === Complex{Float16}(4.0, 4.6)
        @test twice(Complex{Float32}(2.0, 2.3)) === Complex{Float32}(4.0, 4.6)
        @test twice(Complex{Float64}(2.0, 2.3)) === Complex{Float64}(4.0, 4.6)
        @test twice(Complex{BigFloat}(2.0, 2.3)) isa Complex{BigFloat}
        @test twice(Complex{BigFloat}(2.0, 2.3)) == Complex(4.0, 4.6)
        @test twice(Complex(2//3, 3//8)) === Complex(4//3, 3//4)
        @test twice(Complex{BigInt}, HalfInt(2)) isa Complex{BigInt}
        @test twice(Complex{BigInt}, HalfInt(2)) == 4
        @test twice(Complex{BigInt}, HalfInt(3/2)) == 3
        @test twice(Complex{BigInt}, 3) isa Complex{BigInt}
        @test twice(Complex{BigInt}, 3) == 6
        @test twice(Complex{BigInt}, Float16(2.5)) isa Complex{BigInt}
        @test twice(Complex{BigInt}, Float32(2.5)) isa Complex{BigInt}
        @test twice(Complex{BigInt}, Float64(2.5)) isa Complex{BigInt}
        @test twice(Complex{BigInt}, BigFloat(2.5)) isa Complex{BigInt}
        @test twice(Complex{BigInt}, 17//2) isa Complex{BigInt}
        @test twice(Complex{BigInt}, Float16(2.5)) == 5
        @test twice(Complex{BigInt}, Float32(2.5)) == 5
        @test twice(Complex{BigInt}, Float64(2.5)) == 5
        @test twice(Complex{BigInt}, BigFloat(2.5)) == 5
        @test twice(Complex{BigInt}, 17//2) == 17
        @test twice(Complex{BigInt}, Complex(HalfInt(2), HalfInt(3/2))) isa Complex{BigInt}
        @test twice(Complex{BigInt}, Complex(HalfInt(2), HalfInt(3/2))) == 4 + 3im
        @test twice(Complex{BigInt}, Complex(3,4)) isa Complex{BigInt}
        @test twice(Complex{BigInt}, Complex(3,4)) == 6 + 8im
        @test twice(Complex{BigInt}, Complex(Float16(2.5),Float16(2.0))) isa Complex{BigInt}
        @test twice(Complex{BigInt}, Complex(Float32(2.5),Float32(2.0))) isa Complex{BigInt}
        @test twice(Complex{BigInt}, Complex(Float64(2.5),Float64(2.0))) isa Complex{BigInt}
        @test twice(Complex{BigInt}, Complex(BigFloat(2.5),BigFloat(2.0))) isa Complex{BigInt}
        @test twice(Complex{BigInt}, Complex(17//2,3//2)) isa Complex{BigInt}
        @test twice(Complex{BigInt}, Complex(Float16(2.5),Float16(2.0))) == 5 + 4im
        @test twice(Complex{BigInt}, Complex(Float32(2.5),Float32(2.0))) == 5 + 4im
        @test twice(Complex{BigInt}, Complex(Float64(2.5),Float64(2.0))) == 5 + 4im
        @test twice(Complex{BigInt}, Complex(BigFloat(2.5),BigFloat(2.0))) == 5 + 4im
        @test twice(Complex{BigInt}, Complex(17//2,3//2)) == 17 + 3im
        @test_throws InexactError twice(Complex{BigInt}, Float16(2.3))
        @test_throws InexactError twice(Complex{BigInt}, Float32(2.3))
        @test_throws InexactError twice(Complex{BigInt}, Float64(2.3))
        @test_throws InexactError twice(Complex{BigInt}, BigFloat(2.3))
        @test_throws InexactError twice(Complex{BigInt}, 1//5)
        @test_throws InexactError twice(Complex{BigInt}, Complex(Float16(2.5), Float16(2.3)))
        @test_throws InexactError twice(Complex{BigInt}, Complex(Float32(2.3), Float32(2.0)))
        @test_throws InexactError twice(Complex{BigInt}, Complex(Float64(2.5), Float64(2.3)))
        @test_throws InexactError twice(Complex{BigInt}, Complex(BigFloat(2.3), BigFloat(2.0)))
        @test_throws InexactError twice(Complex{BigInt}, Complex(17//2, 1//5))
    end
end

@testset "onehalf" begin
    for T in (halfinttypes..., halfuinttypes...)
        @eval @test onehalf($T) === $T(1/2)
        @eval @test onehalf(Complex{$T}) === Complex($T(1/2), $T(0))
    end
    @test onehalf(BigHalfInt) isa BigHalfInt
    @test onehalf(BigHalfInt) == BigHalfInt(1/2)
    @test onehalf(Complex{BigHalfInt}) isa Complex{BigHalfInt}
    @test onehalf(Complex{BigHalfInt}) == Complex(BigHalfInt(1/2), BigHalfInt(0))
    @test onehalf(Rational{Int}) === 1//2
    @test onehalf(Rational{UInt8}) === UInt8(1)//UInt8(2)
    @test onehalf(Rational{BigInt}) isa Rational{BigInt}
    @test onehalf(Rational{BigInt}) == 1//2
    @test onehalf(Float16) === Float16(0.5)
    @test onehalf(Float32) === Float32(0.5)
    @test onehalf(Float64) === Float64(0.5)
    @test onehalf(BigFloat) isa BigFloat
    @test onehalf(BigFloat) == 0.5
    @test onehalf(Complex{Rational{Int}}) === Complex(1//2, 0//1)
    @test onehalf(Complex{Rational{UInt8}}) === Complex(UInt8(1)//UInt8(2), UInt8(0)//UInt8(1))
    @test onehalf(Complex{Rational{BigInt}}) isa Complex{Rational{BigInt}}
    @test onehalf(Complex{Rational{BigInt}}) == 1//2
    @test onehalf(Complex{Float16}) === Complex(Float16(0.5), Float16(0.0))
    @test onehalf(Complex{Float32}) === Complex(Float32(0.5), Float32(0.0))
    @test onehalf(Complex{Float64}) === Complex(Float64(0.5), Float64(0.0))
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
        @test ishalfinteger(missing) === missing
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

    @testset "typemin/typemax" begin
        for T in (inttypes..., uinttypes...)
            @eval @test typemin(Half{$T}) === half(Half{$T}, typemin($T))
            @eval @test typemax(Half{$T}) === half(Half{$T}, typemax($T))
        end
    end

    @testset "one/zero/isone/iszero" begin
        for T in halfinttypes
            @eval @test one($T) === $T(1)
            @eval @test zero($T) === $T(0)
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
        @test one(BigHalfInt) isa BigHalfInt
        @test one(BigHalfInt) == 1
        @test zero(BigHalfInt) isa BigHalfInt
        @test zero(BigHalfInt) == 0
        @test isone(BigHalfInt(1))
        @test !isone(BigHalfInt(0))
        @test !isone(BigHalfInt(-1))
        @test !isone(BigHalfInt(1/2))
        @test !isone(BigHalfInt(-1/2))
        @test iszero(BigHalfInt(0))
        @test !iszero(BigHalfInt(1))
        @test !iszero(BigHalfInt(-1))
        @test !iszero(BigHalfInt(1/2))
        @test !iszero(BigHalfInt(-1/2))
    end

    @testset "numerator/denominator" begin
        for T in (inttypes..., uinttypes...)
            @eval @test @inferred(numerator(Half{$T}(7/2))) === $T(7)
            @eval @test numerator(Half{$T}(3)) === $T(3)
            @eval @test @inferred(denominator(Half{$T}(7/2))) === $T(2)
            @eval @test denominator(Half{$T}(3)) === $T(1)
        end
        @test @inferred(numerator(BigHalfInt(7/2))) isa BigInt
        @test numerator(BigHalfInt(7/2)) == 7
        @test numerator(BigHalfInt(3)) == 3
        @test @inferred(denominator(BigHalfInt(7/2))) isa BigInt
        @test denominator(BigHalfInt(7/2)) == 2
        @test denominator(BigHalfInt(3)) == 1
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
        for T in halfinttypes
            @eval @test +$T(5/2) === $T(5/2)
            @eval @test -$T(5/2) === $T(-5/2)
            @eval @test $T(1/2) + $T(2) === $T(5/2)
            @eval @test $T(1/2) - $T(2) === $T(-3/2)
            @eval @test $T(3/2) + (-2) == -1/2
            @eval @test $T(3/2) - (-2) == 7/2
            @eval @test (3/2) + $T(-2) == -1/2
            @eval @test (3/2) - $T(-2) == 7/2
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
        @test HalfInt8(3/2) + HalfInt64(1/2) === HalfInt64(2)
        @test HalfInt8(3/2) - HalfInt64(1/2) === HalfInt64(1)
        @test HalfInt32(5/2) + 3 === HalfInt(11/2)
        @test 2.5 + HalfInt16(3) === 5.5
        @test +BigHalfInt(5/2) isa BigHalfInt
        @test -BigHalfInt(5/2) isa BigHalfInt
        @test BigHalfInt(1/2) + BigHalfInt(2) isa BigHalfInt
        @test BigHalfInt(1/2) - BigHalfInt(2) isa BigHalfInt
        @test BigHalfInt(1/2) + 2 isa BigHalfInt
        @test BigHalfInt(1/2) - 2 isa BigHalfInt
        @test 1/2 + BigHalfInt(2) isa BigFloat
        @test 1/2 - BigHalfInt(2) isa BigFloat
        @test +BigHalfInt(5/2) == BigHalfInt(5/2)
        @test -BigHalfInt(5/2) == BigHalfInt(-5/2)
        @test BigHalfInt(1/2) + BigHalfInt(2) == BigHalfInt(5/2)
        @test BigHalfInt(1/2) - BigHalfInt(2) == BigHalfInt(-3/2)
        @test BigHalfInt(1/2) + 2 == BigHalfInt(5/2)
        @test BigHalfInt(1/2) - 2 == BigHalfInt(-3/2)
        @test 1/2 + BigHalfInt(2) == BigHalfInt(5/2)
        @test 1/2 - BigHalfInt(2) == BigHalfInt(-3/2)
    end

    @testset "Multiplication" begin
        @test typemax(HalfInt8)*typemax(HalfInt8) === 16_129/4
        for T in (halfinttypes..., halfuinttypes...)
            @eval @test $T(3/2) * $T(5/2) === 3.75
            @eval @test $T(3/2) * $T(2) === 3.0
            @eval @test $T(3/2) * 2 isa HalfInteger
            @eval @test $T(3/2) * 2 == HalfInt(3)
            @eval @test $T(3/2) * BigInt(2) isa BigHalfInt
            @eval @test $T(3/2) * BigInt(2) == 3
            @eval @test $T(3/2) * Float16(2.5) === Float16(3.75)
            @eval @test $T(3/2) * Float32(2.5) === Float32(3.75)
            @eval @test $T(3/2) * Float64(2.5) === Float64(3.75)
            @eval @test $T(3/2) * BigFloat(2.5) isa BigFloat
            @eval @test $T(3/2) * BigFloat(2.5) == 3.75
            @eval @test $T(3/2) * (5//2) isa Rational
            @eval @test $T(3/2) * (5//2) == 15//4
            @eval @test $T(3/2) * (big(5)//big(2)) isa Rational{BigInt}
            @eval @test $T(3/2) * (big(5)//big(2)) == 15//4
            @eval @test 2 * $T(3/2) isa HalfInteger
            @eval @test 2 * $T(3/2) == HalfInt(3)
            @eval @test BigInt(2) * $T(3/2) isa BigHalfInt
            @eval @test BigInt(2) * $T(3/2) == 3
            @eval @test Float16(2.5) * $T(3/2) === Float16(3.75)
            @eval @test Float32(2.5) * $T(3/2) === Float32(3.75)
            @eval @test Float64(2.5) * $T(3/2) === Float64(3.75)
            @eval @test BigFloat(2.5) * $T(3/2) isa BigFloat
            @eval @test BigFloat(2.5) * $T(3/2) == 3.75
            @eval @test (5//2) * $T(3/2) isa Rational
            @eval @test (5//2) * $T(3/2) == 15//4
            @eval @test (big(5)//big(2)) * $T(3/2) isa Rational{BigInt}
            @eval @test (big(5)//big(2)) * $T(3/2) == 15//4
        end
        @test HalfInt16(3/2) * HalfUInt128(5/2) == 3.75
        @test @inferred(BigHalfInt(3/2) * BigHalfInt(5/2)) isa BigFloat
        @test @inferred(BigHalfInt(3/2) * 2) isa BigHalfInt
        @test @inferred(BigHalfInt(3/2) * BigInt(2)) isa BigHalfInt
        @test @inferred(BigHalfInt(3/2) * Float16(2.5)) isa BigFloat
        @test @inferred(BigHalfInt(3/2) * Float32(2.5)) isa BigFloat
        @test @inferred(BigHalfInt(3/2) * Float64(2.5)) isa BigFloat
        @test @inferred(BigHalfInt(3/2) * BigFloat(2.5)) isa BigFloat
        @test @inferred(BigHalfInt(3/2) * (5//2)) isa Rational{BigInt}
        @test BigHalfInt(3/2) * BigHalfInt(5/2) == 3.75
        @test BigHalfInt(3/2) * BigHalfInt(2) == 3.0
        @test BigHalfInt(3/2) * 2 == 3
        @test BigHalfInt(3/2) * BigInt(2) == 3
        @test BigHalfInt(3/2) * Float16(2.5) == 3.75
        @test BigHalfInt(3/2) * Float32(2.5) == 3.75
        @test BigHalfInt(3/2) * Float64(2.5) == 3.75
        @test BigHalfInt(3/2) * BigFloat(2.5) == 3.75
        @test BigHalfInt(3/2) * (5//2) == 15//4
        @test @inferred(2* BigHalfInt(3/2)) isa BigHalfInt
        @test @inferred(BigInt(2) * BigHalfInt(3/2)) isa BigHalfInt
        @test @inferred(Float16(2.5) * BigHalfInt(3/2)) isa BigFloat
        @test @inferred(Float32(2.5) * BigHalfInt(3/2)) isa BigFloat
        @test @inferred(Float64(2.5) * BigHalfInt(3/2)) isa BigFloat
        @test @inferred(BigFloat(2.5) * BigHalfInt(3/2)) isa BigFloat
        @test @inferred((5//2) * BigHalfInt(3/2)) isa Rational{BigInt}
        @test 2* BigHalfInt(3/2) == 3
        @test BigInt(2) * BigHalfInt(3/2) == 3
        @test Float16(2.5) * BigHalfInt(3/2) == 3.75
        @test Float32(2.5) * BigHalfInt(3/2) == 3.75
        @test Float64(2.5) * BigHalfInt(3/2) == 3.75
        @test BigFloat(2.5) * BigHalfInt(3/2) == 3.75
        @test (5//2) * BigHalfInt(3/2) == 15//4
    end

    @testset "Division" begin
        @testset "/" begin
            for T in (halfinttypes..., halfuinttypes...)
                @eval @test $T(3/2) / $T(2) === 0.75
                @eval @test $T(3/2) / 2 === 0.75
                @eval @test $T(3/2) / BigInt(2) isa BigFloat
                @eval @test $T(3/2) / BigInt(2) == 0.75
                @eval @test $T(3/2) / Float16(2.0) === Float16(0.75)
                @eval @test $T(3/2) / Float32(2.0) === Float32(0.75)
                @eval @test $T(3/2) / Float64(2.0) === Float64(0.75)
                @eval @test $T(3/2) / BigFloat(2.0) isa BigFloat
                @eval @test $T(3/2) / BigFloat(2.0) == 0.75
                @eval @test $T(3/2) / (2//3) isa Rational
                @eval @test $T(3/2) / (2//3) == 9//4
                @eval @test 3 / $T(2) === 1.5
                @eval @test BigInt(3) / $T(2) isa BigFloat
                @eval @test BigInt(3) / $T(2) == 1.5
                @eval @test Float16(3.0) / $T(2) === Float16(1.5)
                @eval @test Float32(3.0) / $T(2) === Float32(1.5)
                @eval @test Float64(3.0) / $T(2) === Float64(1.5)
                @eval @test BigFloat(3.0) / $T(2) isa BigFloat
                @eval @test BigFloat(3.0) / $T(2) == 1.5
                @eval @test (2//3) / $T(5/2) isa Rational
                @eval @test (2//3) / $T(5/2) == 4//15
            end
            @test HalfInt128(3/2) / HalfInt16(3/2) == 1.0
            @test BigHalfInt(3/2) / BigHalfInt(3/2) isa BigFloat
            @test BigHalfInt(3/2) / 2 isa BigFloat
            @test BigHalfInt(3/2) / BigInt(2) isa BigFloat
            @test BigHalfInt(3/2) / Float16(2.0) isa BigFloat
            @test BigHalfInt(3/2) / Float32(2.0) isa BigFloat
            @test BigHalfInt(3/2) / Float64(2.0) isa BigFloat
            @test BigHalfInt(3/2) / BigFloat(2.0) isa BigFloat
            @test BigHalfInt(3/2) / (4//3) isa Rational{BigInt}
            @test BigHalfInt(3/2) / BigHalfInt(2) == 0.75
            @test BigHalfInt(3/2) / 2 == 0.75
            @test BigHalfInt(3/2) / BigInt(2) == 0.75
            @test BigHalfInt(3/2) / Float16(2.0) == 0.75
            @test BigHalfInt(3/2) / Float32(2.0) == 0.75
            @test BigHalfInt(3/2) / Float64(2.0) == 0.75
            @test BigHalfInt(3/2) / BigFloat(2.0) == 0.75
            @test BigHalfInt(3/2) / (4//3) == 9//8
            @test 2 / BigHalfInt(2) isa BigFloat
            @test BigInt(2) / BigHalfInt(3/2) isa BigFloat
            @test Float16(2.0) / BigHalfInt(3/2) isa BigFloat
            @test Float32(2.0) / BigHalfInt(3/2) isa BigFloat
            @test Float64(2.0) / BigHalfInt(3/2) isa BigFloat
            @test BigFloat(2.0) / BigHalfInt(3/2) isa BigFloat
            @test (1//3) / BigHalfInt(3/2) isa Rational{BigInt}
            @test 2 / BigHalfInt(2) == 1.0
            @test BigInt(2) / BigHalfInt(2) == 1.0
            @test Float16(2.0) / BigHalfInt(2) == 1.0
            @test Float32(2.0) / BigHalfInt(2) == 1.0
            @test Float64(2.0) / BigHalfInt(2) == 1.0
            @test BigFloat(2.0) / BigHalfInt(2) == 1.0
            @test (4//3) / BigHalfInt(3/2) == 8//9
        end

        @testset "\\" begin
            for T in (halfinttypes..., halfuinttypes...)
                @eval @test $T(2) \ $T(3/2) === 0.75
                @eval @test 2 \ $T(3/2) === 0.75
                @eval @test BigInt(2) \ $T(3/2) isa BigFloat
                @eval @test BigInt(2) \ $T(3/2) == 0.75
                @eval @test Float16(2.0) \ $T(3/2) === Float16(0.75)
                @eval @test Float32(2.0) \ $T(3/2) === Float32(0.75)
                @eval @test Float64(2.0) \ $T(3/2) === Float64(0.75)
                @eval @test BigFloat(2.0) \ $T(3/2) isa BigFloat
                @eval @test BigFloat(2.0) \ $T(3/2) == 0.75
                @eval @test (2//3) \ $T(3/2) isa Rational
                @eval @test (2//3) \ $T(3/2) == 9//4
                @eval @test $T(2) \ 3 === 1.5
                @eval @test $T(2) \ BigInt(3) isa BigFloat
                @eval @test $T(2) \ BigInt(3) == 1.5
                @eval @test $T(2) \ Float16(3.0) === Float16(1.5)
                @eval @test $T(2) \ Float32(3.0) === Float32(1.5)
                @eval @test $T(2) \ Float64(3.0) === Float64(1.5)
                @eval @test $T(2) \ BigFloat(3.0) isa BigFloat
                @eval @test $T(2) \ BigFloat(3.0) == 1.5
                @eval @test $T(5/2) \ (2//3) isa Rational
                @eval @test $T(5/2) \ (2//3) == 4//15
            end
            @test HalfInt16(3/2) \ HalfInt128(3/2) == 1.0
            @test BigHalfInt(3/2) \ BigHalfInt(3/2) isa BigFloat
            @test 2 \ BigHalfInt(3/2) isa BigFloat
            @test BigInt(2) \ BigHalfInt(3/2) isa BigFloat
            @test Float16(2.0) \ BigHalfInt(3/2) isa BigFloat
            @test Float32(2.0) \ BigHalfInt(3/2) isa BigFloat
            @test Float64(2.0) \ BigHalfInt(3/2) isa BigFloat
            @test BigFloat(2.0) \ BigHalfInt(3/2) isa BigFloat
            @test (4//3) \ BigHalfInt(3/2) isa Rational{BigInt}
            @test BigHalfInt(2) \ BigHalfInt(3/2) == 0.75
            @test 2 \ BigHalfInt(3/2) == 0.75
            @test BigInt(2) \ BigHalfInt(3/2) == 0.75
            @test Float16(2.0) \ BigHalfInt(3/2) == 0.75
            @test Float32(2.0) \ BigHalfInt(3/2) == 0.75
            @test Float64(2.0) \ BigHalfInt(3/2) == 0.75
            @test BigFloat(2.0) \ BigHalfInt(3/2) == 0.75
            @test (4//3) \ BigHalfInt(3/2) == 9//8
            @test BigHalfInt(2) \ 2 isa BigFloat
            @test BigHalfInt(3/2) \ BigInt(2) isa BigFloat
            @test BigHalfInt(3/2) \ Float16(2.0) isa BigFloat
            @test BigHalfInt(3/2) \ Float32(2.0) isa BigFloat
            @test BigHalfInt(3/2) \ Float64(2.0) isa BigFloat
            @test BigHalfInt(3/2) \ BigFloat(2.0) isa BigFloat
            @test BigHalfInt(3/2) \ (1//3) isa Rational{BigInt}
            @test BigHalfInt(2) \ 2 == 1.0
            @test BigHalfInt(2) \ BigInt(2) == 1.0
            @test BigHalfInt(2) \ Float16(2.0) == 1.0
            @test BigHalfInt(2) \ Float32(2.0) == 1.0
            @test BigHalfInt(2) \ Float64(2.0) == 1.0
            @test BigHalfInt(2) \ BigFloat(2.0) == 1.0
            @test BigHalfInt(3/2) \ (4//3) == 8//9
        end

        @testset "//" begin
            for T in (halfinttypes..., halfuinttypes...)
                @eval @test $T(7/2) // $T(5/2) isa Rational
                @eval @test $T(7/2) // $T(5/2) == 7//5
                @eval @test $T(3/2) // 2 isa Rational
                @eval @test $T(3/2) // 2 == 3//4
                @eval @test $T(3/2) // BigInt(2) isa Rational{BigInt}
                @eval @test $T(3/2) // BigInt(2) == 3//4
                @eval @test $T(3/2) // (2//3) isa Rational
                @eval @test $T(3/2) // (2//3) == 9//4
                @eval @test 2 // $T(3/2) isa Rational
                @eval @test 2 // $T(3/2) == 4//3
                @eval @test BigInt(2) // $T(3/2) isa Rational{BigInt}
                @eval @test BigInt(2) // $T(3/2) == 4//3
                @eval @test (2//3) // $T(3/2) isa Rational
                @eval @test (2//3) // $T(3/2) == 4//9
            end
            @test HalfInt128(3/2) // HalfInt16(3/2) == 1//1
            @test BigHalfInt(3/2) // BigHalfInt(3/2) isa Rational{BigInt}
            @test BigHalfInt(3/2) // 2 isa Rational{BigInt}
            @test BigHalfInt(3/2) // BigInt(2) isa Rational{BigInt}
            @test BigHalfInt(3/2) // (4//3) isa Rational{BigInt}
            @test BigHalfInt(3/2) // BigHalfInt(2) == 3//4
            @test BigHalfInt(3/2) // 2 == 3//4
            @test BigHalfInt(3/2) // BigInt(2) == 3//4
            @test BigHalfInt(3/2) // (4//3) == 9//8
            @test 2 // BigHalfInt(2) isa Rational{BigInt}
            @test BigInt(2) // BigHalfInt(3/2) isa Rational{BigInt}
            @test (1//3) // BigHalfInt(3/2) isa Rational{BigInt}
            @test 2 // BigHalfInt(2) == 1//1
            @test BigInt(2) // BigHalfInt(2) == 1//1
            @test (4//3) // BigHalfInt(3/2) == 8//9
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
        @test ℯ^BigHalfInt(5/2) isa BigFloat
        @test ℯ^(BigHalfInt(5/2)*im) isa Complex{BigFloat}
        @test ℯ^BigHalfInt(5/2) == exp(BigHalfInt(5/2))
        @test ℯ^(BigHalfInt(5/2)*im) == exp(BigHalfInt(5/2)*im)
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
                    @eval @test gcd($T(3/2)) == $T(3/2)
                    @eval @test lcm($T(3/2)) == $T(3/2)

                    # Two arguments
                    @eval @test lcm($T(1), $T(1/2)) == $T(1)
                    @eval @test lcm($T(1), $T(3/2)) == $T(3)
                    @eval @test lcm($T(2), $T(3/2)) == $T(6)
                    @eval @test lcm($T(3/2), $T(3/2)) == $T(3/2)
                    @eval @test lcm($T(5/2), $T(3/2)) == $T(15/2)
                    @eval @test lcm(1, $T(1/2)) == 1
                    @eval @test lcm(1//1, $T(3/2)) == 3
                    @eval @test lcm(big(2), $T(3/2)) == 6
                    @eval @test lcm($T(1/2), 1) == 1
                    @eval @test lcm($T(3/2), 1//1) == 3
                    @eval @test lcm($T(3/2), big(2)) == 6
                    @eval @test @inferred(lcm($T(3/2), BigHalfInt(2))) isa BigHalfInt
                    @eval @test @inferred(lcm(BigHalfInt(3/2), $T(2))) isa BigHalfInt
                    @eval @test lcm($T(3/2), BigHalfInt(1)) == 3
                    @eval @test lcm(BigHalfInt(3/2), $T(2)) == 6
                    @eval @test gcd($T(1), $T(3/2)) == $T(1/2)
                    @eval @test gcd($T(2), $T(3/2)) == $T(1/2)
                    @eval @test gcd($T(3), $T(3/2)) == $T(3/2)
                    @eval @test gcd($T(3), $T(9/2)) == $T(3/2)
                    @eval @test gcd($T(3/2), $T(3/2)) == $T(3/2)
                    @eval @test gcd(1, $T(3/2)) == 1/2
                    @eval @test gcd(2//1, $T(3/2)) == 1/2
                    @eval @test gcd(big(3), $T(3/2)) == 3/2
                    @eval @test gcd($T(3/2), 2) == 1/2
                    @eval @test gcd($T(3/2), 3//1) == 3/2
                    @eval @test gcd($T(9/2), big(3)) == 3/2
                    @eval @test @inferred(gcd($T(9/2), BigHalfInt(3))) isa BigHalfInt
                    @eval @test @inferred(gcd(BigHalfInt(9/2), $T(3))) isa BigHalfInt
                    @eval @test gcd($T(3/2), BigHalfInt(2)) == 1/2
                    @eval @test gcd(BigHalfInt(3/2), $T(1)) == 1/2

                    # Three arguments
                    @eval @test lcm($T(2), $T(3/2), $T(2)) == $T(6)
                    @eval @test lcm($T(2), $T(3/2), $T(3/2)) == $T(6)
                    @eval @test lcm($T(2), $T(3/2), $T(3)) == $T(6)
                    @eval @test lcm($T(2), $T(3/2), $T(6)) == $T(6)
                    @eval @test lcm($T(3/2), 2, $T(3)) == 6
                    @eval @test lcm($T(3/2), 2, 3//1) == 6
                    @eval @test lcm(2, $T(3/2), $T(3)) == 6
                    @eval @test lcm(2, $T(3/2), 3) == 6
                    @eval @test lcm(2//1, 3, $T(3/2)) == 6
                    @eval @test @inferred(lcm($T(3/2), $T(3/2), BigHalfInt(2))) isa BigHalfInt
                    @eval @test @inferred(lcm(BigHalfInt(3/2), $T(2), $T(2))) isa BigHalfInt
                    @eval @test lcm($T(3/2), $T(3), BigHalfInt(2)) == 6
                    @eval @test lcm(BigHalfInt(3/2), $T(2), $T(3)) == 6
                    @eval @test gcd($T(3), $T(9/2), $T(1)) == $T(1/2)
                    @eval @test gcd(3, 6, $T(9/2)) == 3/2
                    @eval @test gcd($T(9/2), 3//1, $T(3/2)) == 3/2
                    @eval @test @inferred(gcd($T(9/2), $T(6), BigHalfInt(3))) isa BigHalfInt
                    @eval @test @inferred(gcd(BigHalfInt(9/2), $T(3), $T(3/2))) isa BigHalfInt
                    @eval @test gcd($T(9/2), $T(6), BigHalfInt(3)) == 3/2
                    @eval @test gcd(BigHalfInt(9/2), $T(3), $T(3/2)) == 3/2

                    # Four arguments
                    @eval @test lcm($T(2), $T(3/2), $T(2), $T(3)) == $T(6)
                    @eval @test lcm($T(2), $T(3/2), $T(6), $T(3/2)) == $T(6)
                    @eval @test lcm($T(3/2), 2, 3, $T(1/2)) == 6
                    @eval @test lcm(2//1, 3, $T(6), $T(1/2)) == 6
                    @eval @test lcm(2, 3, 6//1, $T(1/2)) == 6
                    @eval @test @inferred(lcm($T(3/2), $T(3/2), $T(2), BigHalfInt(2))) isa BigHalfInt
                    @eval @test @inferred(lcm(BigHalfInt(3/2), $T(3/2), $T(2), $T(2))) isa BigHalfInt
                    @eval @test lcm($T(3/2), $T(3), $T(1/2), BigHalfInt(2)) == 6
                    @eval @test lcm(BigHalfInt(3/2), $T(2), $T(3), $T(1/2)) == 6
                    @eval @test gcd($T(3), $T(9/2), $T(3), $T(9/2)) == $T(3/2)
                    @eval @test gcd(3, 6, $T(3/2), $T(9/2)) == 3/2
                    @eval @test gcd(3//1, 6, 2, $T(9/2)) == 1/2
                    @eval @test gcd($T(9/2), big(3), $T(3/2), $T(4)) == 1/2
                    @eval @test @inferred(gcd($T(9/2), $T(6), $T(5), BigHalfInt(3))) isa BigHalfInt
                    @eval @test @inferred(gcd(BigHalfInt(9/2), $T(3), $T(3/2), $T(2))) isa BigHalfInt
                    @eval @test gcd($T(9/2), $T(6), $T(5), BigHalfInt(3)) == 1/2
                    @eval @test gcd(BigHalfInt(9/2), $T(3), $T(3/2), $T(9)) == 3/2
                end
                for T in halfinttypes
                    @eval @test gcd($T(-5/2), $T(3/2)) === $T(1/2)
                end
                @test @inferred(lcm(BigHalfInt(1/2))) isa BigHalfInt
                @test @inferred(lcm(BigHalfInt(1), BigHalfInt(1/2))) isa BigHalfInt
                @test @inferred(lcm(BigHalfInt(1), BigHalfInt(1/2), BigHalfInt(3/2))) isa BigHalfInt
                @test @inferred(lcm(BigHalfInt(1), BigHalfInt(1/2), BigHalfInt(3/2), BigHalfInt(3))) isa BigHalfInt
                @test @inferred(gcd(BigHalfInt(1))) isa BigHalfInt
                @test @inferred(gcd(BigHalfInt(1), BigHalfInt(3/2))) isa BigHalfInt
                @test @inferred(gcd(BigHalfInt(1), BigHalfInt(3/2), BigHalfInt(3))) isa BigHalfInt
                @test @inferred(gcd(BigHalfInt(1), BigHalfInt(3/2), BigHalfInt(3), BigHalfInt(1/2))) isa BigHalfInt
            end

            @testset "gcd/lcm for arrays" begin
                @test lcm([HalfInt(2), HalfInt(3/2)]) === HalfInt(6)
                @test lcm([HalfInt(2), HalfInt(3/2), HalfInt(3)]) === HalfInt(6)
                @test lcm([HalfInt(3/2), 2, 3//2]) == 6//1
                @test gcd([HalfInt(3), HalfInt(9/2)]) === HalfInt(3/2)
                @test gcd([3, 9//2, HalfInt(1)]) == 1//2
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
        for T in halfinttypes
            @eval @test abs($T(0)) === $T(0)
            @eval @test abs($T(1)) === $T(1)
            @eval @test abs($T(11/2)) === $T(11/2)
            @eval @test abs($T(-1/2)) === $T(1/2)
            @eval @test abs($T(-3)) === $T(3)
        end
        for T in halfuinttypes
            @eval @test abs($T(0)) === $T(0)
            @eval @test abs($T(1)) === $T(1)
            @eval @test abs($T(11/2)) === $T(11/2)
        end
        @test @inferred(abs(BigHalfInt(0))) isa BigHalfInt
        @test abs(BigHalfInt(0)) == BigHalfInt(0)
        @test abs(BigHalfInt(1)) == BigHalfInt(1)
        @test abs(BigHalfInt(11/2)) == BigHalfInt(11/2)
        @test abs(BigHalfInt(-1/2)) == BigHalfInt(1/2)
        @test abs(BigHalfInt(-3)) == BigHalfInt(3)
    end

    @testset "abs2" begin
        @test @inferred(abs2(BigHalfInt(0))) isa BigFloat
        for T in (halfinttypes..., :BigHalfInt)
            @eval @test abs2($T(0)) == 0.0
            @eval @test abs2($T(1)) == 1.0
            @eval @test abs2($T(11/2)) == 30.25
            @eval @test abs2($T(-1/2)) == 0.25
            @eval @test abs2($T(-3)) == 9.0
        end
        for T in halfuinttypes
            @eval @test abs2($T(0)) == 0.0
            @eval @test abs2($T(1)) == 1.0
            @eval @test abs2($T(11/2)) == 30.25
        end
    end

    @testset "sign" begin
        for T in (halfinttypes..., :BigHalfInt)
            @eval @test sign($T(0)) == 0
            @eval @test sign($T(1)) == 1
            @eval @test sign($T(11/2)) == 1
            @eval @test sign($T(-1/2)) == -1
            @eval @test sign($T(-3)) == -1
        end
        for T in halfuinttypes
            @eval @test sign($T(0)) == 0
            @eval @test sign($T(1)) == 1
            @eval @test sign($T(11/2)) == 1
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
            @eval @test @inferred(flipsign($T(3/2), -1)) isa $T
            @eval @test @inferred(flipsign($T(3/2), 1.0)) isa $T
            @eval @test @inferred(flipsign($T(3/2), $T(1))) isa $T
            @eval @test flipsign($T(0), $T(-3/2)) == 0
            @eval @test flipsign($T(0), 4) == 0
            @eval @test flipsign($T(11/2), $T(-7/2)) == -11/2
            @eval @test flipsign($T(11/2), 5.0) == 11/2
            @eval @test flipsign($T(-1/2), $T(3/2)) == -1/2
            @eval @test flipsign($T(-1/2), -1//3) == 1/2
        end
        for T in halfuinttypes
            @eval @test @inferred(flipsign($T(3/2), 5)) isa $T
            @eval @test @inferred(flipsign($T(3/2), 1.0)) isa $T
            @eval @test @inferred(flipsign($T(3/2), $T(1))) isa $T
            @eval @test flipsign($T(0), $T(3/2)) == 0
            @eval @test flipsign($T(0), -5) == 0
            @eval @test flipsign($T(11/2), 1//3) == 11/2
            @eval @test flipsign($T(11/2), 0.0) == 11/2
        end
    end

    @testset "Complex" begin
        for T in (halfinttypes..., halfuinttypes..., :BigHalfInt)
            @eval @test $T(9/2)*im isa Complex{$T}
            @eval @test $T(9/2)*im == (9//2)*im
            @eval @test big(3) + $T(9/2)*im isa Complex{BigHalfInt}
            @eval @test big(3) + $T(9/2)*im == 3 + (9//2)*im
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
        for T in (halfinttypes..., halfuinttypes..., :BigHalfInt)
            @eval @test @inferred(round($T(3))) isa $T
            @eval @test @inferred(round($T(3), RoundNearest)) isa $T
            @eval @test @inferred(round($T(3), RoundNearestTiesAway)) isa $T
            @eval @test @inferred(round($T(3), RoundNearestTiesUp)) isa $T
            @eval @test @inferred(round($T(3), RoundToZero)) isa $T
            @eval @test @inferred(round($T(3), RoundDown)) isa $T
            @eval @test @inferred(round($T(3), RoundUp)) isa $T
            @eval @test round($T(3))   == 3
            @eval @test round($T(5/2)) == 2
            @eval @test round($T(7/2)) == 4
            @eval @test round($T(3),   RoundNearest) == 3
            @eval @test round($T(5/2), RoundNearest) == 2
            @eval @test round($T(7/2), RoundNearest) == 4
            @eval @test round($T(3),   RoundNearestTiesAway) == 3
            @eval @test round($T(5/2), RoundNearestTiesAway) == 3
            @eval @test round($T(7/2), RoundNearestTiesAway) == 4
            @eval @test round($T(3),   RoundNearestTiesUp) == 3
            @eval @test round($T(5/2), RoundNearestTiesUp) == 3
            @eval @test round($T(7/2), RoundNearestTiesUp) == 4
            @eval @test round($T(3),   RoundToZero) == 3
            @eval @test round($T(5/2), RoundToZero) == 2
            @eval @test round($T(7/2), RoundToZero) == 3
            @eval @test round($T(3),   RoundDown) == 3
            @eval @test round($T(5/2), RoundDown) == 2
            @eval @test round($T(7/2), RoundDown) == 3
            @eval @test round($T(3),   RoundUp) == 3
            @eval @test round($T(5/2), RoundUp) == 3
            @eval @test round($T(7/2), RoundUp) == 4
            for S in (:Integer, :Int, :Int8, :Int16, :Int32, :Int64, :Int128, :BigInt,
                      :UInt, :UInt8, :UInt16, :UInt32, :UInt64, :UInt128)
                @eval @test @inferred(round($S, $T(3))) isa $S
                @eval @test @inferred(round($S, $T(3), RoundNearest)) isa $S
                @eval @test @inferred(round($S, $T(3), RoundNearestTiesAway)) isa $S
                @eval @test @inferred(round($S, $T(3), RoundNearestTiesUp)) isa $S
                @eval @test @inferred(round($S, $T(3), RoundToZero)) isa $S
                @eval @test @inferred(round($S, $T(3), RoundDown)) isa $S
                @eval @test @inferred(round($S, $T(3), RoundUp)) isa $S
                @eval @test round($S, $T(3))   == 3
                @eval @test round($S, $T(5/2)) == 2
                @eval @test round($S, $T(7/2)) == 4
                @eval @test round($S, $T(3),   RoundNearest) == 3
                @eval @test round($S, $T(5/2), RoundNearest) == 2
                @eval @test round($S, $T(7/2), RoundNearest) == 4
                @eval @test round($S, $T(3),   RoundNearestTiesAway) == 3
                @eval @test round($S, $T(5/2), RoundNearestTiesAway) == 3
                @eval @test round($S, $T(7/2), RoundNearestTiesAway) == 4
                @eval @test round($S, $T(3),   RoundNearestTiesUp) == 3
                @eval @test round($S, $T(5/2), RoundNearestTiesUp) == 3
                @eval @test round($S, $T(7/2), RoundNearestTiesUp) == 4
                @eval @test round($S, $T(3),   RoundToZero) == 3
                @eval @test round($S, $T(5/2), RoundToZero) == 2
                @eval @test round($S, $T(7/2), RoundToZero) == 3
                @eval @test round($S, $T(3),   RoundDown) == 3
                @eval @test round($S, $T(5/2), RoundDown) == 2
                @eval @test round($S, $T(7/2), RoundDown) == 3
                @eval @test round($S, $T(3),   RoundUp) == 3
                @eval @test round($S, $T(5/2), RoundUp) == 3
                @eval @test round($S, $T(7/2), RoundUp) == 4
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
            for S in (:Integer, :Int, :Int8, :Int16, :Int32, :Int64, :Int128, :BigInt)
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
            for S in (:UInt, :UInt8, :UInt16, :UInt32, :UInt64, :UInt128)
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
        for T in (halfinttypes..., halfuinttypes..., :BigHalfInt)
            @eval @test @inferred(ceil($T(3))) isa $T
            @eval @test @inferred(floor($T(3))) isa $T
            @eval @test @inferred(trunc($T(3))) isa $T
            @eval @test ceil($T(3))   == 3
            @eval @test ceil($T(5/2)) == 3
            @eval @test ceil($T(7/2)) == 4
            @eval @test floor($T(3))   == 3
            @eval @test floor($T(5/2)) == 2
            @eval @test floor($T(7/2)) == 3
            @eval @test trunc($T(3))   == 3
            @eval @test trunc($T(5/2)) == 2
            @eval @test trunc($T(7/2)) == 3
            for S in (:Integer, :Int, :Int8, :Int16, :Int32, :Int64, :Int128, :BigInt,
                      :UInt, :UInt8, :UInt16, :UInt32, :UInt64, :UInt128)
                @eval @test @inferred(ceil($S, $T(3))) isa $S
                @eval @test @inferred(floor($S, $T(3))) isa $S
                @eval @test @inferred(trunc($S, $T(3))) isa $S
                @eval @test ceil($S, $T(3))   == 3
                @eval @test ceil($S, $T(5/2)) == 3
                @eval @test ceil($S, $T(7/2)) == 4
                @eval @test floor($S, $T(3))   == 3
                @eval @test floor($S, $T(5/2)) == 2
                @eval @test floor($S, $T(7/2)) == 3
                @eval @test trunc($S, $T(3))   == 3
                @eval @test trunc($S, $T(5/2)) == 2
                @eval @test trunc($S, $T(7/2)) == 3
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
            for S in (:Integer, :Int, :Int8, :Int16, :Int32, :Int64, :Int128, :BigInt)
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
            for S in (:UInt, :UInt8, :UInt16, :UInt32, :UInt64, :UInt128)
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
    @testset "sinpi" begin
        for T in halfinttypes
            @eval @test sinpi($T(0)) === 0.0
            @eval @test sinpi($T(1/2)) === 1.0
            @eval @test sinpi($T(-1)) === -0.0
            @eval @test sinpi($T(5/2)) === 1.0
            @eval @test sinpi($T(-5/2)) === -1.0
        end
        for T in halfuinttypes
            @eval @test sinpi($T(0)) === 0.0
            @eval @test sinpi($T(1/2)) === 1.0
            @eval @test sinpi($T(1)) === 0.0
            @eval @test sinpi($T(5/2)) === 1.0
            @eval @test sinpi($T(7/2)) === -1.0
        end
        @test @inferred(sinpi(BigHalfInt(0))) isa BigFloat
        @test isequal(sinpi(BigHalfInt(0)), 0.0)
        @test isequal(sinpi(BigHalfInt(1/2)), 1.0)
        @test isequal(sinpi(BigHalfInt(-1)), -0.0)
        @test isequal(sinpi(BigHalfInt(5/2)), 1.0)
        @test isequal(sinpi(BigHalfInt(-5/2)), -1.0)
    end

    @testset "cospi" begin
        for T in halfinttypes
            @eval @test cospi($T(0)) === 1.0
            @eval @test cospi($T(1/2)) === 0.0
            @eval @test cospi($T(-1)) === -1.0
            @eval @test cospi($T(2)) === 1.0
            @eval @test cospi($T(5/2)) === 0.0
            @eval @test cospi($T(-5/2)) === 0.0
        end
        for T in halfuinttypes
            @eval @test cospi($T(0)) === 1.0
            @eval @test cospi($T(1/2)) === 0.0
            @eval @test cospi($T(1)) === -1.0
            @eval @test cospi($T(2)) === 1.0
            @eval @test cospi($T(5/2)) === 0.0
            @eval @test cospi($T(7/2)) === 0.0
        end
        @test @inferred(cospi(BigHalfInt(0))) isa BigFloat
        @test isequal(cospi(BigHalfInt(0)), 1.0)
        @test isequal(cospi(BigHalfInt(1/2)), 0.0)
        @test isequal(cospi(BigHalfInt(-1)), -1.0)
        @test isequal(cospi(BigHalfInt(2)), 1.0)
        @test isequal(cospi(BigHalfInt(5/2)), 0.0)
        @test isequal(cospi(BigHalfInt(-5/2)), 0.0)
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
        @test tryparse(BigHalfInt, "123456789123456789123456789123456789123456789") == 
            BigHalfInt(123456789123456789123456789123456789123456789)
        @test tryparse(BigHalfInt, "123456789123456789123456789123456789123456789/2") == 
            BigHalfInt(123456789123456789123456789123456789123456789//2)
        @eval @test tryparse(BigHalfInt, "4") == BigHalfInt(4)
        @eval @test tryparse(BigHalfInt, "+1/2\n") == BigHalfInt(1/2)
        @eval @test tryparse(BigHalfInt, " -5 / 2") == BigHalfInt(-5/2)
        @eval @test tryparse(BigHalfInt, " +-3/2") === nothing
        @eval @test tryparse(BigHalfInt, " 5/3") === nothing
        @eval @test tryparse(BigHalfInt, "e/2") === nothing
        @test parse(BigHalfInt, "123456789123456789123456789123456789123456789") == 
            BigHalfInt(123456789123456789123456789123456789123456789)
        @test parse(BigHalfInt, "123456789123456789123456789123456789123456789/2") == 
            BigHalfInt(123456789123456789123456789123456789123456789//2)
        @eval @test @inferred(parse(BigHalfInt, "4")) isa BigHalfInt
        @eval @test parse(BigHalfInt, "4") == BigHalfInt(4)
        @eval @test parse(BigHalfInt, "+1/2\n") == BigHalfInt(1/2)
        @eval @test parse(BigHalfInt, " -5 / 2") == BigHalfInt(-5/2)
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

include("ranges.jl")
include("saferintegers.jl")
include("customtypes.jl")
