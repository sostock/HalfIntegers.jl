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
