@testset "Checked arithmetic" begin

    using Base: checked_abs, checked_neg, checked_add, checked_sub, checked_mul,
                checked_cld, checked_div, checked_fld, checked_mod, checked_rem
    using Base.Checked: add_with_overflow, sub_with_overflow, mul_with_overflow
    using HalfIntegers: checked_twice

    @testset "Base.checked_abs" begin
        for T in halfinttypes
            @eval @test checked_abs($T(5//2)) ==ₜ $T(5//2)
            @eval @test checked_abs($T(-3//2)) ==ₜ $T(3//2)
            @eval @test_throws OverflowError checked_abs(typemin($T))
            @eval @test abs(typemin($T)) ==ₜ typemin($T) # unchecked `abs` overflows
        end
        for T in halfuinttypes
            @eval @test checked_abs($T(5//2)) ==ₜ $T(5//2)
        end
        @test checked_abs(BigHalfInt(-3//2)) ==ₜ BigHalfInt(3//2)
        @test checked_abs(BigHalfInt(5//2)) ==ₜ BigHalfInt(5//2)
    end

    @testset "Base.checked_neg" begin
        for T in halfinttypes
            @eval @test checked_neg(typemax($T)) ==ₜ typemin($T) + onehalf($T)
            @eval @test_throws OverflowError checked_neg(typemin($T))
            @eval @test -typemin($T) ==ₜ typemin($T) # unchecked `-` overflows
        end
        for T in halfuinttypes
            @eval @test checked_neg(zero($T)) ==ₜ zero($T)
            @eval @test_throws OverflowError checked_neg(onehalf($T))
            @eval @test -onehalf($T) ==ₜ typemax($T) # unchecked `-` overflows
        end
        @test checked_neg(BigHalfInt(-3//2)) ==ₜ BigHalfInt(3//2)
        @test checked_neg(BigHalfInt(5//2)) ==ₜ BigHalfInt(-5//2)
    end

    @testset "HalfIntegers.checked_twice" begin
        for T in (inttypes..., uinttypes...)
            @eval @test checked_twice($T(5)) ==ₜ $T(10)
            @eval @test_throws OverflowError checked_twice(typemax($T))
            @eval @test checked_twice(typemax(Half{$T})) ==ₜ typemax($T)
        end
        @test twice(typemax(Int)) ==ₜ -2 # unchecked `twice` overflows
        @test twice(typemax(UInt)) ==ₜ typemax(UInt) - one(UInt) # unchecked `twice` overflows
        @test checked_twice(BigInt(100)) ==ₜ BigInt(200)
        @test checked_twice(BigHalfInt(100)) ==ₜ BigInt(200)
        @test checked_twice(0.375) ==ₜ 0.75
        @test checked_twice(3//8) ==ₜ 3//4
    end

    @testset "Base.checked_add" begin
        for T in (halfinttypes..., halfuinttypes...)
            @eval @test checked_add($T(5//2), $T(3//2)) ==ₜ $T(4)
            @eval @test_throws OverflowError checked_add(typemax($T), one($T))
            @eval @test typemax($T) + onehalf($T) == typemin($T) # unchecked `+` overflows
        end
        @test checked_add(BigHalfInt(5//2), BigHalfInt(-3//2)) ==ₜ BigHalfInt(1)
        # Mixed HalfInteger types
        @test_throws InexactError checked_add(HalfInt(-1), HalfUInt(3/2))
        @test_throws InexactError checked_add(HalfInt(-2), HalfUInt(3/2))
        @test_broken HalfInt(-1) + HalfUInt(3/2) ==ₜ HalfUInt(1/2) # This should work, since it matches the Integer behavior
        @test_broken HalfInt(-2) + HalfUInt(3/2) ==ₜ typemax(HalfUInt) # This should work, since it matches the Integer behavior
        # Mixed Integer/HalfInteger
        @test checked_add(HalfInt8(50), Int8(10)) ==ₜ HalfInt8(60)
        @test_throws OverflowError checked_add(HalfInt8(50), Int8(100))
        @test_throws OverflowError checked_add(HalfInt8(-50), Int8(100))
        @test HalfInt8(50) + Int8(100) ==ₜ HalfInt8(22) # (100 + 200) % Int8 == 44
        @test HalfInt8(-50) + Int8(100) ==ₜ HalfInt8(50) # (-100 + 200) % Int8 == 100
    end

    @testset "Base.checked_sub" begin
        for T in (halfinttypes..., halfuinttypes...)
            @eval @test checked_sub($T(5//2), $T(3//2)) ==ₜ $T(1)
            @eval @test_throws OverflowError checked_sub(typemin($T), one($T))
            @eval @test typemin($T) - onehalf($T) == typemax($T) # unchecked `-` overflows
        end
        @test checked_sub(BigHalfInt(5//2), BigHalfInt(-3//2)) ==ₜ BigHalfInt(4)
        # Mixed HalfInteger types
        @test_throws InexactError checked_sub(HalfUInt(3/2), HalfInt(-1))
        @test_throws InexactError checked_sub(HalfInt(-1/2), HalfUInt(0))
        @test_broken HalfUInt(3/2) - HalfInt(-1) ==ₜ HalfUInt(5/2) # This should work, since it matches the Integer behavior
        @test_broken HalfInt(-1/2) - HalfUInt(0) ==ₜ typemax(HalfUInt) # This should work, since it matches the Integer behavior
        # Mixed Integer/HalfInteger
        @test checked_sub(HalfInt8(50), Int8(10)) ==ₜ HalfInt8(40)
        @test_throws OverflowError checked_sub(HalfInt8(50), Int8(100))
        @test_throws OverflowError checked_sub(HalfInt8(-50), Int8(100))
        @test HalfInt8(50) - Int8(100) ==ₜ HalfInt8(-50) # (100 - 200) % Int8 == -100
        @test HalfInt8(-50) - Int8(100) ==ₜ HalfInt8(-22) # (-100 - 200) % Int8 == -44
    end

    @testset "Base.checked_mul" begin
        for T in (halfinttypes..., halfuinttypes...)
            @eval @test typemax($T) * one($T) ==ₜ float(typemax($T)) # `*(::HalfInteger, ::HalfInteger)` uses float arithmetic, so no overflow
            @eval @test checked_mul(typemax($T), one($T)) ==ₜ float(typemax($T))
        end
        @test checked_mul(BigHalfInt(7/2), BigHalfInt(3/2)) ==ₜ BigFloat(5.25)
        # Mixed HalfInteger types
        @test checked_mul(HalfInt8(7/2), HalfUInt16(3/2)) ==ₜ 5.25
        # Mixed HalfInteger/Integer
        @test Int8(100) * HalfInt8(1) == HalfInt8(-28) # (100*2) % Int8 == -56
        @test HalfInt8(50) * Int8(2) == HalfInt8(-28) # (100*2) % Int8 == -56
        @test_throws OverflowError checked_mul(Int8(100), HalfInt8(1))
        @test_throws OverflowError checked_mul(HalfInt8(50), Int8(2))
    end

    @testset "Base.$checked_op" for (op, checked_op) = ((:cld,:checked_cld), (:div,:checked_div), (:fld,:checked_fld))
        for T in inttypes
            @eval @test_throws DivideError $op(typemin(Half{$T}), Half{$T}(-1/2)) # op is already checked
            @eval @test_throws DivideError $checked_op(typemin(Half{$T}), Half{$T}(-1/2))
            @eval @test $checked_op(Half{$T}(6), Half{$T}(5/2)) ==ₜ $op(Half{$T}(6), Half{$T}(5/2))
            @eval @test $checked_op(Half{$T}(-6), Half{$T}(5/2)) ==ₜ $op(Half{$T}(-6), Half{$T}(5/2))
        end
        for T in uinttypes
            @eval @test $checked_op(Half{$T}(6), Half{$T}(5/2)) ==ₜ $op(Half{$T}(6), Half{$T}(5/2))
        end
        @eval @test $checked_op(BigHalfInt(6), BigHalfInt(5/2)) ==ₜ $op(BigHalfInt(6), BigHalfInt(5/2))
        @eval @test $checked_op(-BigHalfInt(6), BigHalfInt(5/2)) ==ₜ $op(-BigHalfInt(6), BigHalfInt(5/2))
        # Mixed HalfInteger/Integer
        for T in (inttypes..., uinttypes...)
            @eval @test $checked_op($T(6), Half{$T}(5/2)) ==ₜ $op($T(6), Half{$T}(5/2))
            @eval @test $checked_op(Half{$T}(15/2), $T(5)) ==ₜ $op(Half{$T}(15/2), $T(5))
            @eval @test_throws OverflowError $checked_op(typemax($T), Half{$T}(5/2))
            @eval @test_throws OverflowError $checked_op(Half{$T}(15/2), typemax($T))
            @eval @test_broken try; $op(typemax($T), Half{$T}(5/2)); catch e; e; end isa OverflowError
            @eval @test_broken try; $op(Half{$T}(15/2), typemax($T)); catch e; e; end isa OverflowError
        end
        @eval @test $checked_op(BigInt(6), BigHalfInt(5/2)) ==ₜ $op(BigInt(6), BigHalfInt(5/2))
        @eval @test $checked_op(-BigInt(6), BigHalfInt(5/2)) ==ₜ $op(-BigInt(6), BigHalfInt(5/2))
        @eval @test $checked_op(BigHalfInt(15/2), BigInt(5)) ==ₜ $op(BigHalfInt(15/2), BigInt(5))
        @eval @test $checked_op(-BigHalfInt(15/2), BigInt(5)) ==ₜ $op(-BigHalfInt(15/2), BigInt(5))
    end

    @testset "Base.$checked_op" for (op, checked_op) = ((:mod,:checked_mod), (:rem,:checked_rem))
        for T in (inttypes..., :BigInt)
            @eval @test $checked_op(Half{$T}(6), Half{$T}(5/2)) ==ₜ $op(Half{$T}(6), Half{$T}(5/2))
            @eval @test $checked_op(Half{$T}(-6), Half{$T}(5/2)) ==ₜ $op(Half{$T}(-6), Half{$T}(5/2))
        end
        for T in uinttypes
            @eval @test $checked_op(Half{$T}(6), Half{$T}(5/2)) ==ₜ $op(Half{$T}(6), Half{$T}(5/2))
        end
        # Mixed HalfInteger/Integer
        for T in (inttypes..., uinttypes...)
            @eval @test $checked_op($T(6), Half{$T}(5/2)) ==ₜ $op($T(6), Half{$T}(5/2))
            @eval @test $checked_op(Half{$T}(15/2), $T(5)) ==ₜ $op(Half{$T}(15/2), $T(5))
            @eval @test_throws OverflowError $checked_op(typemax($T), Half{$T}(5/2))
            @eval @test_throws OverflowError $checked_op(Half{$T}(15/2), typemax($T))
            @eval @test_broken try; $op(typemax($T), Half{$T}(5/2)); catch e; e; end isa OverflowError
            @eval @test_broken try; $op(Half{$T}(15/2), typemax($T)); catch e; e; end isa OverflowError
        end
        @eval @test $checked_op(BigInt(6), BigHalfInt(5/2)) ==ₜ $op(BigInt(6), BigHalfInt(5/2))
        @eval @test $checked_op(-BigInt(6), BigHalfInt(5/2)) ==ₜ $op(-BigInt(6), BigHalfInt(5/2))
        @eval @test $checked_op(BigHalfInt(15/2), BigInt(5)) ==ₜ $op(BigHalfInt(15/2), BigInt(5))
        @eval @test $checked_op(-BigHalfInt(15/2), BigInt(5)) ==ₜ $op(-BigHalfInt(15/2), BigInt(5))
    end

    @testset "Base.Checked.add_with_overflow" begin
        for T in (halfinttypes..., halfuinttypes...)
            @eval @test add_with_overflow($T(5//2), $T(3//2)) ==ₜ ($T(4), false)
            @eval @test add_with_overflow(typemax($T), onehalf($T)) ==ₜ (typemin($T), true)
        end
        @test add_with_overflow(BigHalfInt(5//2), BigHalfInt(-3//2)) ==ₜ (BigHalfInt(1), false)
    end

    @testset "Base.Checked.sub_with_overflow" begin
        for T in (halfinttypes..., halfuinttypes...)
            @eval @test sub_with_overflow($T(5//2), $T(3//2)) ==ₜ ($T(1), false)
            @eval @test sub_with_overflow(typemin($T), onehalf($T)) ==ₜ (typemax($T), true)
        end
        @test sub_with_overflow(BigHalfInt(5//2), BigHalfInt(-3//2)) ==ₜ (BigHalfInt(4), false)
    end

    @testset "Base.Checked.mul_with_overflow" begin
        for T in (halfinttypes..., halfuinttypes...)
            @eval @test mul_with_overflow(typemax($T), one($T)) ==ₜ (float(typemax($T)), false)
        end
        @test mul_with_overflow(BigHalfInt(7/2), BigHalfInt(3/2)) ==ₜ (BigFloat(5.25), false)
        # Mixed HalfInteger types
        @test mul_with_overflow(HalfInt8(7/2), HalfUInt16(3/2)) ==ₜ (5.25, false)
        # Mixed HalfInteger/Integer
        @test mul_with_overflow(Int(100), HalfInt(3/2)) ==ₜ (HalfInt(150), false)
        @test mul_with_overflow(Int8(100), HalfInt8(3/2)) ==ₜ (HalfInt8(22), true)
        @test mul_with_overflow(HalfInt(101/2), Int(2)) ==ₜ (HalfInt(101), false)
        @test mul_with_overflow(HalfInt8(101/2), Int8(2)) ==ₜ (HalfInt8(-27), true)
    end

    @static if VERSION ≥ v"1.1"
        # In Julia < 1.1, zero(Half{T}) and one(Half{T}) do not work for
        # T ∈ [SafeInt8, SafeInt16, SafeUInt8, SafeUInt16] due to a bug in Julia, cf.
        # https://github.com/JuliaLang/julia/issues/32203

        using SaferIntegers

        safeinttypes  = (:SafeInt, :SafeInt8, :SafeInt16, :SafeInt32, :SafeInt64, :SafeInt128)
        safeuinttypes = (:SafeUInt, :SafeUInt8, :SafeUInt16, :SafeUInt32, :SafeUInt64, :SafeUInt128)

        @testset "SaferIntegers" begin
            @test_throws OverflowError Half{SafeInt8}(typemax(Int8))
            @test_throws OverflowError typemax(Half{SafeInt8}) + one(HalfInt8)
            @test_throws OverflowError typemax(Half{SafeInt8}) + one(Int8)
            @test_throws OverflowError typemin(Half{SafeInt8}) - one(HalfInt8)
            @test_throws OverflowError typemin(Half{SafeInt8}) - one(Int8)
            for T in safeinttypes
                @eval @test HalfInteger(one($T)) === one(Half{$T})
                @eval @test_throws OverflowError Half{$T}(typemax($T))
                @eval @test_throws OverflowError Half{$T}(typemin($T))
                @eval @test_throws OverflowError Half{$T}(typemax($T)//one($T))
                @eval @test_throws OverflowError Half{$T}(typemin($T)//one($T))
                @eval @test_throws OverflowError Half{$T}(complex(typemax($T)))
                @eval @test_throws OverflowError Half{$T}(complex(typemin($T)))
                @eval @test_throws OverflowError Half{$T}(complex(typemax($T)//one($T)))
                @eval @test_throws OverflowError Half{$T}(complex(typemin($T)//one($T)))
                @eval @test_throws OverflowError -typemin(Half{$T})
                @eval @test_throws OverflowError abs(typemin(Half{$T}))
                @eval @test_throws OverflowError flipsign(typemin(Half{$T}), -1)
                @eval @test_throws OverflowError typemax(Half{$T}) + onehalf(Half{$T})
                @eval @test_throws OverflowError typemin(Half{$T}) - onehalf(Half{$T})
                @eval @test_throws OverflowError twice(typemax($T))
                @eval @test_throws OverflowError twice(typemin($T))
                @eval @test_throws OverflowError round(typemax(Half{$T}))
                @eval @test_throws OverflowError round(typemax(Half{$T}), RoundNearest)
                @eval @test_throws OverflowError round(typemax(Half{$T}), RoundNearestTiesAway)
                @eval @test_throws OverflowError round(typemax(Half{$T}), RoundNearestTiesUp)
                @eval @test_throws OverflowError round(typemax(Half{$T}), RoundUp)
            end
            for T in safeuinttypes
                @eval @test HalfInteger(one($T)) === one(Half{$T})
                @eval @test_throws OverflowError Half{$T}(typemax($T))
                @eval @test_throws OverflowError Half{$T}(typemax($T)//one($T))
                @eval @test_throws OverflowError Half{$T}(complex(typemax($T)))
                @eval @test_throws OverflowError Half{$T}(complex(typemax($T)//one($T)))
                @eval @test_throws OverflowError -onehalf(Half{$T})
                @eval @test_throws OverflowError flipsign(onehalf(Half{$T}), -1)
                @eval @test_throws OverflowError typemax(Half{$T}) + onehalf(Half{$T})
                @eval @test_throws OverflowError typemin(Half{$T}) - onehalf(Half{$T})
                @eval @test_throws OverflowError twice(typemax($T))
                @eval @test_throws OverflowError round(typemax(Half{$T}))
                @eval @test_throws OverflowError round(typemax(Half{$T}), RoundNearest)
                @eval @test_throws OverflowError round(typemax(Half{$T}), RoundNearestTiesAway)
                @eval @test_throws OverflowError round(typemax(Half{$T}), RoundNearestTiesUp)
                @eval @test_throws OverflowError round(typemax(Half{$T}), RoundUp)
            end
        end
    end
end
