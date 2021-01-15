@testset "Ranges" begin
    # @test range(half(1), half(2), length=3)[2]

    @testset "UnitRange" begin
        for T in (halfinttypes..., halfuinttypes..., :BigHalfInt)
            @eval @test UnitRange{$T}(1//2, 5//1) isa UnitRange{$T}
            @eval @test UnitRange($T(1/2), $T(5)) isa UnitRange{$T}
            @eval @test $T(1/2):$T(5) isa UnitRange{$T}
            @eval @test $T(1/2):big(5) isa UnitRange{BigHalfInt}
            @eval @test first($T(1/2):$T(5)) == $T(1/2)
            @eval @test last($T(1/2):$T(5)) == $T(9/2)
            @eval @test length($T(1/2):$T(5)) == 5
            @eval @test length($T(1/2):$T(0)) == 0
            @eval @test length($T(1/2):$T(1/2)) == 1
            @eval @test length($T(1/2):$T(1)) == 1
            @eval @test $T(5/2) ∉ $T(1):$T(5)
            @eval @test $T(5/2) ∈ $T(1/2):$T(5)
            @eval @test $T(2) ∈ $T(1):$T(5)
            @eval @test $T(2) ∉ $T(1/2):$T(5)
            @eval @test 2.5 ∉ $T(1):$T(5)
            @eval @test 2.5 ∈ $T(1/2):$T(5)
            @eval @test 5//2 ∉ $T(1):$T(5)
            @eval @test 5//2 ∈ $T(1/2):$T(5)
            @eval @test 2 ∈ $T(1):$T(5)
            @eval @test 2 ∉ $T(1/2):$T(5)

            @eval @test any(isinteger, $T(1):$T(5))
            @eval @test !any(isinteger, $T(1):$T(0))
            @eval @test !any(isinteger, $T(1/2):$T(5))
            @eval @test !any(isinteger, $T(3/2):$T(0))
            @eval @test !any(!isinteger, $T(1):$T(5))
            @eval @test !any(!isinteger, $T(1):$T(0))
            @eval @test any(!isinteger, $T(1/2):$T(5))
            @eval @test !any(!isinteger, $T(3/2):$T(0))

            @eval @test all(isinteger, $T(1):$T(5))
            @eval @test all(isinteger, $T(1):$T(0))
            @eval @test !all(isinteger, $T(1/2):$T(5))
            @eval @test all(isinteger, $T(3/2):$T(0))
            @eval @test !all(!isinteger, $T(1):$T(5))
            @eval @test all(!isinteger, $T(1):$T(0))
            @eval @test all(!isinteger, $T(1/2):$T(5))
            @eval @test all(!isinteger, $T(3/2):$T(0))
        end
        for T in (halfinttypes..., :BigHalfInt)
            @eval @test first($T(-1/2):$T(1)) == $T(-1/2)
            @eval @test last($T(-1/2):$T(1)) == $T(1/2)
            @eval @test length($T(-1/2):$T(1)) == 2
        end
    end

    @testset "StepRange" begin
        for T in (halfinttypes..., halfuinttypes..., :BigHalfInt)
            @eval @test StepRange{$T,$T}($T(2), $T(1/2), $T(5)) isa StepRange{$T,$T}
            @eval @test StepRange{$T,Int8}($T(2), Int8(2), $T(9/2)) isa StepRange{$T,Int8}
            @eval @test StepRange($T(2), $T(1/2), $T(5)) isa StepRange{$T,$T}
            @eval @test StepRange($T(2), Int8(2), $T(9/2)) isa StepRange{$T,Int8}
            @eval @test StepRange($T(2), big(2), $T(9/2)) isa StepRange{$T,BigInt}

            @eval @test $T(2):$T(1/2):$T(5) isa StepRange{$T,$T}
            @eval @test $T(2):$T(2):$T(9/2) isa StepRange{$T,$T}
            @eval @test $T(2):big(2):$T(9/2) isa StepRange{BigHalfInt,BigInt}
            @eval @test big(2):2:$T(9/2) isa StepRange{BigHalfInt,Int}

            @eval @test $T(2):$T(2):$T(9/2) == $T(2):$T(2):$T(4)
            @eval @test first($T(2):$T(2):$T(9/2)) == 2
            @eval @test step($T(2):$T(2):$T(9/2)) == 2
            @eval @test last($T(2):$T(2):$T(9/2)) == 4
            @eval @test length($T(2):$T(2):$T(9/2)) == 2

            @eval @test first($T(2):$T(1/2):$T(5)) == 2
            @eval @test step($T(2):$T(1/2):$T(5)) == $T(1/2)
            @eval @test last($T(2):$T(1/2):$T(5)) == 5
            @eval @test length($T(2):$T(1/2):$T(5)) == 7

            @eval @test $T(5/2) ∈ $T(1/2):$T(2):$T(7)
            @eval @test $T(5/2) ∉ $T(1/2):$T(5/2):$T(7)
            @eval @test $T(2) ∈ $T(0):$T(1):$T(5/2)
            @eval @test $T(2) ∉ $T(1/2):$T(1):$T(5/2)
            @eval @test 2.5 ∈ $T(1/2):$T(2):$T(7)
            @eval @test 2.5 ∉ $T(1/2):$T(5/2):$T(7)
            @eval @test 5//2 ∈ $T(1/2):$T(2):$T(7)
            @eval @test 5//2 ∈ $T(1/2):2:$T(7)
            @eval @test 5//2 ∈ $T(1/2):2:7
            @eval @test 5//2 ∉ $T(1/2):$T(5/2):$T(7)
            @eval @test 2 ∈ $T(0):$T(1):$T(5/2)
            @eval @test 2 ∉ $T(1/2):$T(1):$T(5/2)
        end
        for T in (halfinttypes..., :BigHalfInt)
            @eval @test $T(2):$T(-1):$T(1/2) == $T(2):$T(-1):$T(1)
            @eval @test first($T(2):$T(-1):$T(1/2)) == 2
            @eval @test step($T(2):$T(-1):$T(1/2)) == -1
            @eval @test last($T(2):$T(-1):$T(1/2)) == 1
            @eval @test length($T(2):$T(-1):$T(1/2)) == 2

            @eval @test $T(5/2) ∉ $T(1/2):$T(-1):$T(-1/2)
            @eval @test 2.5 ∉ $T(1/2):$T(-1):$T(-1/2)
            @eval @test 5//2 ∉ $T(1/2):$T(-1):$T(-1/2)
            @eval @test 5//2 ∉ $T(1/2):-1:$T(-1/2)
        end
    end

    @testset "StepRangeLen" begin
        for T in (halfinttypes..., halfuinttypes..., :BigHalfInt)
            @eval @test StepRangeLen{$T,$T,$T}($T(2), $T(1/2), 4) isa StepRangeLen{$T,$T,$T}
            @eval @test StepRangeLen{$T,$T,$T}($T(2), $T(1/2), 4, 3) isa StepRangeLen{$T,$T,$T}
            @eval @test StepRangeLen{$T,$T,Int8}($T(9/2), Int8(2), 4) isa StepRangeLen{$T,$T,Int8}
            @eval @test StepRangeLen{$T,$T,Int8}($T(9/2), Int8(2), 4, 3) isa StepRangeLen{$T,$T,Int8}
            @eval @test StepRangeLen{$T,Int,Int}(8, 2, 4) isa StepRangeLen{$T,Int,Int}
            @eval @test StepRangeLen{$T,Int,Int}(8, 2, 4, 3) isa StepRangeLen{$T,Int,Int}
            @eval @test StepRangeLen{$T}($T(2), $T(1/2), 4) isa StepRangeLen{$T,$T,$T}
            @eval @test StepRangeLen{$T}($T(2), $T(1/2), 4, 3) isa StepRangeLen{$T,$T,$T}
            @eval @test StepRangeLen{$T}($T(9/2), Int8(2), 4) isa StepRangeLen{$T,$T,Int8}
            @eval @test StepRangeLen{$T}($T(9/2), Int8(2), 4, 3) isa StepRangeLen{$T,$T,Int8}
            @eval @test StepRangeLen{$T}(8, 2, 4) isa StepRangeLen{$T,Int,Int}
            @eval @test StepRangeLen{$T}(8, 2, 4, 3) isa StepRangeLen{$T,Int,Int}
            @eval @test_skip StepRangeLen($T(2), $T(1/2), 4) isa StepRangeLen{$T,$T,$T}
            @eval @test_skip StepRangeLen($T(2), $T(1/2), 4, 3) isa StepRangeLen{$T,$T,$T}
            @eval @test_skip StepRangeLen($T(9/2), Int8(2), 4) isa StepRangeLen{$T,$T,Int8}
            @eval @test_skip StepRangeLen($T(9/2), Int8(2), 4, 3) isa StepRangeLen{$T,$T,Int8}
            @eval @test StepRangeLen($T(9/2), big(2), 4) isa StepRangeLen{BigHalfInt,$T,BigInt}
            @eval @test StepRangeLen($T(9/2), big(2), 4, 3) isa StepRangeLen{BigHalfInt,$T,BigInt}

            @eval @test StepRangeLen{$T}($T(2), $T(1/2), 5) == $T[2, 5/2, 3, 7/2, 4]
            @eval @test first(StepRangeLen{$T}($T(2), $T(1/2), 5)) == $T(2)
            @eval @test step(StepRangeLen{$T}($T(2), $T(1/2), 5)) == $T(1/2)
            @eval @test last(StepRangeLen{$T}($T(2), $T(1/2), 5)) == $T(4)
            @eval @test length(StepRangeLen{$T}($T(2), $T(1/2), 5)) == 5

            @eval @test StepRangeLen{$T}($T(2), $T(1/2), 5, 3) == $T[1, 3/2, 2, 5/2, 3]
            @eval @test first(StepRangeLen{$T}($T(2), $T(1/2), 5, 3)) == $T(1)
            @eval @test step(StepRangeLen{$T}($T(2), $T(1/2), 5, 3)) == $T(1/2)
            @eval @test last(StepRangeLen{$T}($T(2), $T(1/2), 5, 3)) == $T(3)
            @eval @test length(StepRangeLen{$T}($T(2), $T(1/2), 5, 3)) == 5
        end
    end

    @testset "LinRange" begin
        for T in (halfinttypes..., halfuinttypes..., :BigHalfInt)
            @eval @test LinRange{$T}(1/2, 3/2, 3) isa LinRange{$T}
            @eval @test LinRange($T(1/2), $T(3/2), 3) isa LinRange{float($T)}

            @eval @test LinRange{$T}(1/2, 3/2, 3) == $T[1/2, 1, 3/2]
            @eval @test first(LinRange{$T}(1/2, 3/2, 3)) == $T(1/2)
            @eval @test step(LinRange{$T}(1/2, 3/2, 3)) == 0.5
            @eval @test last(LinRange{$T}(1/2, 3/2, 3)) == $T(3/2)
            @eval @test length(LinRange{$T}(1/2, 3/2, 3)) == 3
        end
    end

    @testset "range" begin
        for T in (halfinttypes..., halfuinttypes..., :BigHalfInt)
            @eval @test @inferred(range($T(1/2), stop=$T(5))) isa UnitRange{$T}
            @eval @test @inferred(range($T(1/2), stop=Int8(5))) isa UnitRange{$T}
            @eval @test @inferred(range(Int8(1), stop=$T(7/2))) isa UnitRange{$T}
            @eval @test @inferred(range($T(1/2), stop=big(5))) isa UnitRange{BigHalfInt}
            @eval @test @inferred(range(big(1), stop=$T(7/2))) isa UnitRange{BigHalfInt}
            @eval @test range($T(1/2), stop=$T(5)) == $T[1/2, 3/2, 5/2, 7/2, 9/2]
            @eval @test range($T(1/2), stop=Int8(5)) == $T[1/2, 3/2, 5/2, 7/2, 9/2]
            @eval @test range(Int8(1), stop=$T(7/2)) == $T[1, 2, 3]
            @eval @test range($T(1/2), stop=big(5)) == BigHalfInt[1/2, 3/2, 5/2, 7/2, 9/2]
            @eval @test range(big(1), stop=$T(7/2)) == BigHalfInt[1, 2, 3]
            @static if VERSION ≥ v"1.7.0-DEV.263"
                @eval @test @inferred(range(start=$T(1/2), stop=$T(5))) isa UnitRange{$T}
                @eval @test @inferred(range(start=$T(1/2), stop=Int8(5))) isa UnitRange{$T}
                @eval @test @inferred(range(start=Int8(1), stop=$T(7/2))) isa UnitRange{$T}
                @eval @test @inferred(range(start=$T(1/2), stop=big(5))) isa UnitRange{BigHalfInt}
                @eval @test @inferred(range(start=big(1), stop=$T(7/2))) isa UnitRange{BigHalfInt}
                @eval @test range(start=$T(1/2), stop=$T(5)) == $T[1/2, 3/2, 5/2, 7/2, 9/2]
                @eval @test range(start=$T(1/2), stop=Int8(5)) == $T[1/2, 3/2, 5/2, 7/2, 9/2]
                @eval @test range(start=Int8(1), stop=$T(7/2)) == $T[1, 2, 3]
                @eval @test range(start=$T(1/2), stop=big(5)) == BigHalfInt[1/2, 3/2, 5/2, 7/2, 9/2]
                @eval @test range(start=big(1), stop=$T(7/2)) == BigHalfInt[1, 2, 3]
            end

            @eval @test @inferred(range($T(2), step=$T(1/2), stop=$T(5))) isa StepRange{$T,$T}
            @eval @test @inferred(range($T(2), step=Int8(2), stop=$T(9/2))) isa StepRange{$T,Int8}
            @eval @test @inferred(range($T(2), step=big(2), stop=$T(9/2))) isa StepRange{BigHalfInt,BigInt}
            @eval @test @inferred(range(Int8(2), step=$T(1/2), stop=Int8(5))) isa StepRange{$T,$T}
            @eval @test range($T(2), step=$T(1/2), stop=$T(5)) == $T[2, 5/2, 3, 7/2, 4, 9/2, 5]
            @eval @test range($T(2), step=Int8(2), stop=$T(9/2)) == $T[2, 4]
            @eval @test range($T(2), step=big(2), stop=$T(9/2)) == BigHalfInt[2, 4]
            @eval @test range(Int8(2), step=$T(1/2), stop=Int8(5)) == $T[2, 5/2, 3, 7/2, 4, 9/2, 5]
            @static if VERSION ≥ v"1.7.0-DEV.263"
                @eval @test @inferred(range(start=$T(2), step=$T(1/2), stop=$T(5))) isa StepRange{$T,$T}
                @eval @test @inferred(range(start=$T(2), step=Int8(2), stop=$T(9/2))) isa StepRange{$T,Int8}
                @eval @test @inferred(range(start=$T(2), step=big(2), stop=$T(9/2))) isa StepRange{BigHalfInt,BigInt}
                @eval @test @inferred(range(start=Int8(2), step=$T(1/2), stop=Int8(5))) isa StepRange{$T,$T}
                @eval @test range(start=$T(2), step=$T(1/2), stop=$T(5)) == $T[2, 5/2, 3, 7/2, 4, 9/2, 5]
                @eval @test range(start=$T(2), step=Int8(2), stop=$T(9/2)) == $T[2, 4]
                @eval @test range(start=$T(2), step=big(2), stop=$T(9/2)) == BigHalfInt[2, 4]
                @eval @test range(start=Int8(2), step=$T(1/2), stop=Int8(5)) == $T[2, 5/2, 3, 7/2, 4, 9/2, 5]
            end

            if T === :BigHalfInt
                @eval @test @inferred(range($T(1/2), stop=$T(9/2), length=5)) isa LinRange{BigFloat}
                @eval @test @inferred(range($T(2), stop=Int8(10), length=5)) isa LinRange{BigFloat}
                @eval @test range($T(1/2), stop=$T(9/2), length=5) == [0.5, 1.5, 2.5, 3.5, 4.5]
                @eval @test range($T(2), stop=Int8(10), length=5) == [2, 4, 6, 8, 10]
                @static if VERSION ≥ v"1.7.0-DEV.263"
                    @eval @test @inferred(range(start=$T(1/2), stop=$T(9/2), length=5)) isa LinRange{BigFloat}
                    @eval @test @inferred(range(start=$T(2), stop=Int8(10), length=5)) isa LinRange{BigFloat}
                    @eval @test range(start=$T(1/2), stop=$T(9/2), length=5) == [0.5, 1.5, 2.5, 3.5, 4.5]
                    @eval @test range(start=$T(2), stop=Int8(10), length=5) == [2, 4, 6, 8, 10]
                end
            elseif T === :HalfUInt64
                @eval @test_broken @inferred(range($T(1/2), stop=$T(9/2), length=5)) isa StepRangeLen{Float64,Base.TwicePrecision{Float64},Base.TwicePrecision{Float64}}
                @eval @test_broken range($T(1/2), stop=$T(9/2), length=5) == [0.5, 1.5, 2.5, 3.5, 4.5]
                @static if VERSION ≥ v"1.7.0-DEV.263"
                    @eval @test_broken @inferred(range(start=$T(1/2), stop=$T(9/2), length=5)) isa StepRangeLen{Float64,Base.TwicePrecision{Float64},Base.TwicePrecision{Float64}}
                    @eval @test_broken range(start=$T(1/2), stop=$T(9/2), length=5) == [0.5, 1.5, 2.5, 3.5, 4.5]
                end
                if Int === Int32
                    @eval @test_broken @inferred(range($T(2), stop=Int8(10), length=5)) isa StepRangeLen{Float64,Base.TwicePrecision{Float64},Base.TwicePrecision{Float64}}
                    @eval @test_broken range($T(2), stop=Int8(10), length=5) == [2, 4, 6, 8, 10]
                    @static if VERSION ≥ v"1.7.0-DEV.263"
                        @eval @test_broken @inferred(range(start=$T(2), stop=Int8(10), length=5)) isa StepRangeLen{Float64,Base.TwicePrecision{Float64},Base.TwicePrecision{Float64}}
                        @eval @test_broken range(start=$T(2), stop=Int8(10), length=5) == [2, 4, 6, 8, 10]
                    end
                else
                    @eval @test @inferred(range($T(2), stop=Int8(10), length=5)) isa StepRangeLen{Float64,Base.TwicePrecision{Float64},Base.TwicePrecision{Float64}}
                    @eval @test range($T(2), stop=Int8(10), length=5) == [2, 4, 6, 8, 10]
                    @static if VERSION ≥ v"1.7.0-DEV.263"
                        @eval @test @inferred(range(start=$T(2), stop=Int8(10), length=5)) isa StepRangeLen{Float64,Base.TwicePrecision{Float64},Base.TwicePrecision{Float64}}
                        @eval @test range(start=$T(2), stop=Int8(10), length=5) == [2, 4, 6, 8, 10]
                    end
                end
            elseif T === :HalfUInt128
                @eval @test_broken @inferred(range($T(1/2), stop=$T(9/2), length=5)) isa StepRangeLen{Float64,Base.TwicePrecision{Float64},Base.TwicePrecision{Float64}}
                @eval @test_broken @inferred(range($T(2), stop=Int8(10), length=5)) isa StepRangeLen{Float64,Base.TwicePrecision{Float64},Base.TwicePrecision{Float64}}
                @eval @test_broken range($T(1/2), stop=$T(9/2), length=5) == [0.5, 1.5, 2.5, 3.5, 4.5]
                @eval @test_broken range($T(2), stop=Int8(10), length=5) == [2, 4, 6, 8, 10]
                @static if VERSION ≥ v"1.7.0-DEV.263"
                    @eval @test_broken @inferred(range(start=$T(1/2), stop=$T(9/2), length=5)) isa StepRangeLen{Float64,Base.TwicePrecision{Float64},Base.TwicePrecision{Float64}}
                    @eval @test_broken @inferred(range(start=$T(2), stop=Int8(10), length=5)) isa StepRangeLen{Float64,Base.TwicePrecision{Float64},Base.TwicePrecision{Float64}}
                    @eval @test_broken range(start=$T(1/2), stop=$T(9/2), length=5) == [0.5, 1.5, 2.5, 3.5, 4.5]
                    @eval @test_broken range(start=$T(2), stop=Int8(10), length=5) == [2, 4, 6, 8, 10]
                end
            else
                if Int === Int32 && T ∈ (:HalfUInt32, :HalfUInt64, :HalfUInt128)
                    @eval @test_broken @inferred(range($T(1/2), stop=$T(9/2), length=5)) isa StepRangeLen{Float64,Base.TwicePrecision{Float64},Base.TwicePrecision{Float64}}
                    @eval @test_broken range($T(1/2), stop=$T(9/2), length=5) == [0.5, 1.5, 2.5, 3.5, 4.5]
                    @static if VERSION ≥ v"1.7.0-DEV.263"
                        @eval @test_broken @inferred(range(start=$T(1/2), stop=$T(9/2), length=5)) isa StepRangeLen{Float64,Base.TwicePrecision{Float64},Base.TwicePrecision{Float64}}
                        @eval @test_broken range(start=$T(1/2), stop=$T(9/2), length=5) == [0.5, 1.5, 2.5, 3.5, 4.5]
                    end
                else
                    @eval @test @inferred(range($T(1/2), stop=$T(9/2), length=5)) isa StepRangeLen{Float64,Base.TwicePrecision{Float64},Base.TwicePrecision{Float64}}
                    @eval @test range($T(1/2), stop=$T(9/2), length=5) == [0.5, 1.5, 2.5, 3.5, 4.5]
                    @static if VERSION ≥ v"1.7.0-DEV.263"
                        @eval @test @inferred(range(start=$T(1/2), stop=$T(9/2), length=5)) isa StepRangeLen{Float64,Base.TwicePrecision{Float64},Base.TwicePrecision{Float64}}
                        @eval @test range(start=$T(1/2), stop=$T(9/2), length=5) == [0.5, 1.5, 2.5, 3.5, 4.5]
                    end
                end
                @eval @test @inferred(range($T(2), stop=Int8(10), length=5)) isa StepRangeLen{Float64,Base.TwicePrecision{Float64},Base.TwicePrecision{Float64}}
                @eval @test range($T(2), stop=Int8(10), length=5) == [2, 4, 6, 8, 10]
                @static if VERSION ≥ v"1.7.0-DEV.263"
                    @eval @test @inferred(range(start=$T(2), stop=Int8(10), length=5)) isa StepRangeLen{Float64,Base.TwicePrecision{Float64},Base.TwicePrecision{Float64}}
                    @eval @test range(start=$T(2), stop=Int8(10), length=5) == [2, 4, 6, 8, 10]
                end
            end
            @eval @test @inferred(range(big(10), stop=$T(2), length=5)) isa LinRange{BigFloat}
            @eval @test range(big(10), stop=$T(2), length=5) == [10, 8, 6, 4, 2]
            @static if VERSION ≥ v"1.7.0-DEV.263"
                @eval @test @inferred(range(start=big(10), stop=$T(2), length=5)) isa LinRange{BigFloat}
                @eval @test range(start=big(10), stop=$T(2), length=5) == [10, 8, 6, 4, 2]
            end

            @eval @test @inferred(range($T(2), step=$T(1/2), length=5)) isa StepRange{$T,$T}
            @eval @test @inferred(range($T(1/2), step=Int8(2), length=5)) isa StepRange{$T,Int8}
            @eval @test range($T(2), step=$T(1/2), length=5) == $T[2, 5/2, 3, 7/2, 4]
            @eval @test range($T(1/2), step=Int8(2), length=5) == $T[1/2, 5/2, 9/2, 13/2, 17/2]
            @eval @test range($T(1/2), step=big(2), length=5) == BigHalfInt[1/2, 5/2, 9/2, 13/2, 17/2]
            @static if VERSION ≥ v"1.7.0-DEV.16"
                @eval @test @inferred(range($T(1/2), step=big(2), length=5)) isa StepRange{BigHalfInt,BigInt}
                @eval @test @inferred(range(Int8(2), step=$T(1/2), length=5)) isa StepRange{$T,$T}
                @eval @test range(Int8(2), step=$T(1/2), length=5) == $T[2, 5/2, 3, 7/2, 4]
            else
                if T === :BigHalfInt
                    @eval @test @inferred(range($T(1/2), step=big(2), length=5)) isa StepRange{BigHalfInt,BigInt}
                else
                    @eval @test_broken @inferred(range($T(1/2), step=big(2), length=5)) isa StepRange{BigHalfInt,BigInt}
                end
                @eval @test_broken @inferred(range(Int8(2), step=$T(1/2), length=5)) isa StepRange{$T,$T}
                @eval @test_broken range(Int8(2), step=$T(1/2), length=5) == $T[2, 5/2, 3, 7/2, 4]
            end
            @static if VERSION ≥ v"1.7.0-DEV.263"
                @eval @test @inferred(range(start=$T(2), step=$T(1/2), length=5)) isa StepRange{$T,$T}
                @eval @test @inferred(range(start=$T(1/2), step=Int8(2), length=5)) isa StepRange{$T,Int8}
                @eval @test @inferred(range(start=$T(1/2), step=big(2), length=5)) isa StepRange{BigHalfInt,BigInt}
                @eval @test @inferred(range(start=Int8(2), step=$T(1/2), length=5)) isa StepRange{$T,$T}
                @eval @test range(start=$T(2), step=$T(1/2), length=5) == $T[2, 5/2, 3, 7/2, 4]
                @eval @test range(start=$T(1/2), step=Int8(2), length=5) == $T[1/2, 5/2, 9/2, 13/2, 17/2]
                @eval @test range(start=$T(1/2), step=big(2), length=5) == BigHalfInt[1/2, 5/2, 9/2, 13/2, 17/2]
                @eval @test range(start=Int8(2), step=$T(1/2), length=5) == $T[2, 5/2, 3, 7/2, 4]
            end
        end

        @static if VERSION ≥ v"1.7.0-DEV.263"
            for T in (halfinttypes..., halfuinttypes..., :BigHalfInt)
                if T in (:HalfUInt64, :HalfUInt128) || (Int === Int32 && T === :HalfUInt32)
                    @eval @test_broken @inferred(range(stop=$T(23/2), step=Int8(2), length=5)) isa StepRange{$T,Int8}
                    @eval @test_broken range(stop=$T(23/2), step=Int8(2), length=5) == $T[7/2, 11/2, 15/2, 19/2, 23/2]
                else
                    @eval @test @inferred(range(stop=$T(23/2), step=Int8(2), length=5)) isa StepRange{$T,Int8}
                    @eval @test range(stop=$T(23/2), step=Int8(2), length=5) == $T[7/2, 11/2, 15/2, 19/2, 23/2]
                end
                @eval @test @inferred(range(stop=$T(23/2), step=big(2), length=5)) isa StepRange{BigHalfInt,BigInt}
                @eval @test range(stop=$T(23/2), step=big(2), length=5) == BigHalfInt[7/2, 11/2, 15/2, 19/2, 23/2]
            end
            for T in (halfinttypes..., :BigHalfInt)
                @eval @test @inferred(range(stop=$T(2), step=$T(1/2), length=6)) isa StepRange{$T,$T}
                @eval @test @inferred(range(stop=Int8(2), step=$T(1/2), length=6)) isa StepRange{$T,$T}
                @eval @test range(stop=$T(2), step=$T(1/2), length=6) == $T[-1/2, 0, 1/2, 1, 3/2, 2]
                @eval @test range(stop=Int8(2), step=$T(1/2), length=6) == $T[-1/2, 0, 1/2, 1, 3/2, 2]
            end
        end
    end

    @testset "reverse" begin
        for T in (halfinttypes..., :BigHalfInt)
            # There is currently a discussion on how to treat Unsigned types:
            # * https://github.com/JuliaLang/julia/issues/29576
            # * https://github.com/JuliaLang/julia/pull/29842
            @eval @test @inferred(reverse($T(1/2):$T(9/2))) isa StepRange{$T}
            @eval @test @inferred(reverse($T(9/2):$T(-1):$T(1/2))) isa StepRange{$T}
            @eval @test reverse($T(1/2):$T(9/2)) == $T(9/2):$T(-1):$T(1/2)
            @eval @test reverse($T(9/2):$T(-1):$T(1/2)) == $T(1/2):$T(1):$T(9/2)
            @eval @test reverse($T(1/2):$T(1/2):$T(3)) == $T(3):$T(-1/2):$T(1/2)
            @eval @test reverse($T(-1/2):$T(2):$T(3/2)) == $T(3/2):$T(-2):$T(-1/2)
            @eval @test isempty(reverse($T(3/2):$T(1/2)))
            @eval @test isempty(reverse($T(3/2):$T(1):$T(1/2)))
            @eval @test isempty(reverse($T(3/2):$T(1/2):$T(1)))
            @eval @test isempty(reverse($T(7/2):$T(-2):$T(11/2)))
        end
    end

    @testset "intersect" begin
        for T in (halfinttypes..., halfuinttypes..., :BigHalfInt)
            @eval @test @inferred(($T(1):$T(3)) ∩ ($T(1/2):$T(3))) isa UnitRange{$T}
            @eval @test @inferred((big(1):big(3)) ∩ ($T(1/2):$T(3))) isa UnitRange{BigHalfInt}
            @eval @test @inferred(($T(1/2):$T(3)) ∩ (big(1):big(3))) isa UnitRange{BigHalfInt}
            @eval @test @inferred(($T(3/2):$T(1):$T(5)) ∩ ($T(1):$T(3))) isa StepRange{$T}
            @eval @test @inferred(($T(3/2):$T(1):$T(5)) ∩ (big(1):big(3))) isa StepRange{BigHalfInt}
            @eval @test @inferred((big(1):big(3)) ∩ ($T(3/2):$T(1):$T(5))) isa StepRange{BigHalfInt}
            @eval @test @inferred((big(1):big(3):big(7)) ∩ ($T(3/2):$T(5))) isa StepRange{BigHalfInt}
            @eval @test @inferred(($T(3/2):$T(5)) ∩ (big(1):big(3):big(7))) isa StepRange{BigHalfInt}
            @eval @test @inferred(($T(3/2):$T(1/2):$T(5)) ∩ ($T(1):$T(3):$T(5))) isa StepRange{$T}
            @eval @test @inferred((big(-1):big(3):big(5)) ∩ ($T(3/2):$T(1/2):$T(5))) isa StepRange{BigHalfInt}
            @eval @test @inferred(($T(3/2):$T(1/2):$T(5)) ∩ (big(-1):big(3):big(5))) isa StepRange{BigHalfInt}
            @eval @test isempty(($T(1):$T(3)) ∩ ($T(1/2):$T(3)))
            @eval @test ($T(1/2):$T(2)) ∩ ($T(3/2):$T(3)) == $T(3/2):$T(3/2)
            @eval @test isempty(($T(1/2):$T(2)) ∩ (1:2))
            @eval @test isempty((1:2) ∩ ($T(1/2):$T(2)))
            @eval @test ($T(2):$T(5)) ∩ (1:3) == 2:3
            @eval @test (1:3) ∩ ($T(2):$T(5)) == 2:3
            @eval @test ($T(2):$T(1):$T(5)) ∩ (1:3) == 2:1:3
            @eval @test (1:3) ∩ ($T(2):$T(1):$T(5)) == 2:1:3
            @eval @test isempty(($T(3/2):$T(1):$T(5)) ∩ (1:3))
            @eval @test isempty((1:3) ∩ ($T(3/2):$T(1):$T(5)))
            @eval @test ($T(2):$T(1/2):$T(5)) ∩ (1:3) == 2:1:3
            @eval @test (1:3) ∩ ($T(2):$T(1/2):$T(5)) == 2:1:3
            @eval @test ($T(3/2):$T(1/2):$T(5)) ∩ (1:3) == 2:1:3
            @eval @test (1:3) ∩ ($T(3/2):$T(1/2):$T(5)) == 2:1:3
            @eval @test ($T(2):$T(1):$T(5)) ∩ ($T(1):$T(3)) == $T(2):$T(1):$T(3)
            @eval @test ($T(1):$T(3)) ∩ ($T(2):$T(1):$T(5)) == $T(2):$T(1):$T(3)
            @eval @test isempty(($T(3/2):$T(1):$T(5)) ∩ ($T(1):$T(3)))
            @eval @test isempty(($T(1):$T(3)) ∩ ($T(3/2):$T(1):$T(5)))
            @eval @test ($T(2):$T(1/2):$T(5)) ∩ ($T(1):$T(3)) == $T(2):$T(1):$T(3)
            @eval @test ($T(1):$T(3)) ∩ ($T(2):$T(1/2):$T(5)) == $T(2):$T(1):$T(3)
            @eval @test ($T(3/2):$T(1/2):$T(5)) ∩ ($T(1):$T(3)) == $T(2):$T(1):$T(3)
            @eval @test ($T(1):$T(3)) ∩ ($T(3/2):$T(1/2):$T(5)) == $T(2):$T(1):$T(3)
            @eval @test ($T(3/2):$T(1):$T(6)) ∩ ($T(1):$T(3/2):$T(6)) == $T(5/2):$T(3):$T(11/2)
        end
        for T in (halfinttypes..., :BigHalfInt)
            @eval @test ($T(3/2):$T(1/2):$T(5)) ∩ (-1:3:5) == 2:3:5
            @eval @test (-1:3:5) ∩ ($T(3/2):$T(1/2):$T(5)) == 2:3:5
            @eval @test ($T(2):$T(1):$T(5)) ∩ (-1:3:5) == 2:3:5
            @eval @test (-1:3:5) ∩ ($T(2):$T(1):$T(5)) == 2:3:5
            @eval @test isempty(($T(3/2):$T(1):$T(5)) ∩ (-1:3:5))
            @eval @test isempty((-1:3:5) ∩ ($T(3/2):$T(1):$T(5)))
            @eval @test isempty(($T(3/2):$T(1):$T(5)) ∩ ($T(-1):$T(3):$T(5)))
            @eval @test isempty(($T(-1):$T(3):$T(5)) ∩ ($T(3/2):$T(1):$T(5)))
            @eval @test ($T(3/2):$T(1):$T(5)) ∩ ($T(-1):$T(3/2):$T(5)) == $T(7/2):$T(3):$T(7/2)
            # These tests should in theory also work for Unsigned types, but due to some
            # bugs with ranges of Unsigned integers, they currently don’t (see below)
            @eval @test ($T(5/2):$T(3/2):$T(7)) ∩ ($T(1):$T(8)) == $T(4):$T(3):$T(7)
            @eval @test ($T(1):$T(8)) ∩ ($T(5/2):$T(3/2):$T(7)) == $T(4):$T(3):$T(7)
            @eval @test isempty((1:3:7) ∩ ($T(3/2):$T(5)))
            @eval @test isempty(($T(3/2):$T(5)) ∩ (1:3:7))
            @eval @test (1:3:7) ∩ ($T(3):$T(5)) == 4:3:4
            @eval @test ($T(3):$T(5)) ∩ (1:3:7) == 4:3:4
        end
        # Ranges of UInts are currently broken, cf. e.g.
        # * https://github.com/JuliaLang/julia/issues/29576
        # * https://github.com/JuliaLang/julia/issues/29801
        # * https://github.com/JuliaLang/julia/issues/29810
        # These (or other) bugs related to ranges of Unsigned integers prevent some of the
        # following tests from passing
        for T in halfuinttypes
            @eval @test_broken ($T(5/2):$T(3/2):$T(7)) ∩ ($T(1):$T(8)) == $T(4):$T(3):$T(7)
            @eval @test_broken ($T(1):$T(8)) ∩ ($T(5/2):$T(3/2):$T(7)) == $T(4):$T(3):$T(7)
        end
        for T in (:HalfUInt8, :HalfUInt16)
            @eval @test isempty((1:3:7) ∩ ($T(3/2):$T(5)))
            @eval @test isempty(($T(3/2):$T(5)) ∩ (1:3:7))
            @eval @test (1:3:7) ∩ ($T(3):$T(5)) == 4:3:4
            @eval @test ($T(3):$T(5)) ∩ (1:3:7) == 4:3:4
        end
        @static if Sys.WORD_SIZE == 64
            @test isempty((1:3:7) ∩ (HalfUInt32(3/2):HalfUInt32(5)))
            @test isempty((HalfUInt32(3/2):HalfUInt32(5)) ∩ (1:3:7))
            @test (1:3:7) ∩ (HalfUInt32(3):HalfUInt32(5)) == 4:3:4
            @test (HalfUInt32(3):HalfUInt32(5)) ∩ (1:3:7) == 4:3:4
        else
            @test_broken isempty((1:3:7) ∩ (HalfUInt32(3/2):HalfUInt32(5)))
            @test_broken isempty((HalfUInt32(3/2):HalfUInt32(5)) ∩ (1:3:7))
            @test_broken (1:3:7) ∩ (HalfUInt32(3):HalfUInt32(5)) == 4:3:4
            @test_broken (HalfUInt32(3):HalfUInt32(5)) ∩ (1:3:7) == 4:3:4
        end
        for T in (:HalfUInt64, :HalfUInt128)
            @eval @test_broken isempty((1:3:7) ∩ ($T(3/2):$T(5)))
            @eval @test_broken isempty(($T(3/2):$T(5)) ∩ (1:3:7))
            @eval @test_broken (1:3:7) ∩ ($T(3):$T(5)) == 4:3:4
            @eval @test_broken ($T(3):$T(5)) ∩ (1:3:7) == 4:3:4
        end
    end
end
