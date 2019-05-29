module HalfIntegers

export
    # Abstract types
    HalfInteger,

    # Concrete types
    BigHalfInt,
    Half,
    HalfInt,
    HalfInt8,
    HalfInt16,
    HalfInt32,
    HalfInt64,
    HalfInt128,
    HalfUInt,
    HalfUInt8,
    HalfUInt16,
    HalfUInt32,
    HalfUInt64,
    HalfUInt128,
    
    # Functions
    half,
    ishalfinteger,
    onehalf,
    twice

"""
    HalfInteger <: Real

Abstract supertype for half-integers. Here, every number ``n/2`` where ``n\\in\\mathbb{Z}``
is considered a half-integer, regardless of whether ``n`` is even or odd.
"""
abstract type HalfInteger <: Real end

HalfInteger(x::Real) = HalfInt(x)
HalfInteger(x::HalfInteger) = x
HalfInteger(x::Union{BigInt,BigFloat,Rational{BigInt}}) = BigHalfInt(x)

(T::Type{<:AbstractFloat})(x::HalfInteger) = T(float(x))
(T::Type{<:Integer})(x::HalfInteger) =
    isinteger(x) ? (t=twice(x); T(t÷oftype(t,2))) : throw(InexactError(Symbol(T), T, x))
(T::Type{<:Rational})(x::HalfInteger) = (t=twice(x); T(t,oftype(t,2)))
Base.Bool(x::HalfInteger) = invoke(Bool, Tuple{Real}, x)

for op in (:<, :≤, :(==))
    @eval Base.$op(x::HalfInteger, y::HalfInteger) = $op(twice(x), twice(y))
    @eval Base.$op(x::HalfInteger, y::Integer) = ((pt,py)=promote(twice(x),y); $op(pt, twice(py)))
    @eval Base.$op(x::Integer, y::HalfInteger) = ((px,pt)=promote(x,twice(y)); $op(twice(px), pt))
    @eval Base.$op(x::HalfInteger, y::Rational) = $op(Rational(x), y)
    @eval Base.$op(x::Rational, y::HalfInteger) = $op(x, Rational(y))
end

Base.:+(x::T, y::T) where T<:HalfInteger = half(twice(x)+twice(y))
Base.:+(x::HalfInteger) = half(+twice(x))
Base.:-(x::T, y::T) where T<:HalfInteger = half(twice(x)-twice(y))
Base.:-(x::HalfInteger) = half(-twice(x))

Base.:*(x::T, y::T) where T<:HalfInteger = twice(x)*twice(y)/4
Base.:*(x::HalfInteger, y::Integer) = half(twice(x)*y)
Base.:*(x::Integer, y::HalfInteger) = y*x

Base.:/(x::T, y::T) where T<:HalfInteger = twice(x)/twice(y)

Base.://(x::HalfInteger, y::HalfInteger) = twice(x)//twice(y)
Base.://(x::HalfInteger, y) = twice(x)//twice(y)
Base.://(x, y::HalfInteger) = twice(x)//twice(y)

Base.:^(x::Real, y::HalfInteger) = x^float(y)

Base.div(x::T, y::T) where T<:HalfInteger = div(twice(x), twice(y))
Base.fld(x::T, y::T) where T<:HalfInteger = fld(twice(x), twice(y))
Base.cld(x::T, y::T) where T<:HalfInteger = cld(twice(x), twice(y))
Base.rem(x::T, y::T) where T<:HalfInteger = half(rem(twice(x), twice(y)))
Base.mod(x::T, y::T) where T<:HalfInteger = half(mod(twice(x), twice(y)))

Base.fld1(x::T, y::T) where T<:HalfInteger = fld1(twice(x), twice(y))

Base.ceil(T::Type{<:Integer}, x::HalfInteger)  = round(T, x, RoundUp)
Base.floor(T::Type{<:Integer}, x::HalfInteger) = round(T, x, RoundDown)
Base.trunc(T::Type{<:Integer}, x::HalfInteger) = round(T, x, RoundToZero)

Base.round(T::Type{<:Integer}, x::HalfInteger, r::RoundingMode=RoundNearest) =
    (t=twice(round(x, r)); T(t÷oftype(t,2)))

Base.round(x::HalfInteger, ::typeof(RoundNearest)) =
    ifelse(isinteger(x), +x, ifelse(isone(mod1(twice(x),4)), x-onehalf(x), x+onehalf(x)))
Base.round(x::HalfInteger, ::typeof(RoundNearestTiesAway)) =
    ifelse(isinteger(x), +x, ifelse(x < zero(x), x-onehalf(x), x+onehalf(x)))
Base.round(x::HalfInteger, ::typeof(RoundNearestTiesUp)) =
    ifelse(isinteger(x), +x, x+onehalf(x))
Base.round(x::HalfInteger, ::typeof(RoundToZero)) =
    ifelse(isinteger(x), +x, ifelse(x < zero(x), x+onehalf(x), x-onehalf(x)))
Base.round(x::HalfInteger, ::typeof(RoundUp)) =
    round(x, RoundNearestTiesUp)
Base.round(x::HalfInteger, ::typeof(RoundDown)) =
    ifelse(isinteger(x), +x, x-onehalf(x))

Base.big(x::HalfInteger) = BigHalfInt(x)

Base.decompose(x::HalfInteger) = twice(x), 0, 2

Base.float(x::HalfInteger) = twice(x)/2

Base.isfinite(x::HalfInteger) = isfinite(twice(x))

Base.isinteger(x::HalfInteger) = iseven(twice(x))

Base.show(io::IO, x::HalfInteger) = isinteger(x) ? print(io,twice(x)÷2) : print(io,twice(x),"/2")

Base.sign(x::HalfInteger) = oftype(x, sign(twice(x)))

Base.denominator(x::HalfInteger) = (t=twice(x); ifelse(isinteger(x), one(t), oftype(t,2)))
Base.numerator(x::HalfInteger) = (t=twice(x); ifelse(isinteger(x), t÷oftype(t,2), t))

Base.sinpi(x::HalfInteger) = sinpihalf(twice(x))
Base.cospi(x::HalfInteger) = cospihalf(twice(x))

# Compute sin(x*π/2)
function sinpihalf(x::Integer)
    xm4 = mod(x,4)
    if (xm4 == 0) | (xm4 == 2)
        ifelse(x<0, -float(zero(x)), +float(zero(x)))
    elseif xm4 == 1
        +float(one(x))
    else
        -float(one(x))
    end
end
# Compute cos(x*π/2)
function cospihalf(x::Integer)
    xm4 = mod(x,4)
    if (xm4 == 1) | (xm4 == 3)
        +float(zero(x))
    elseif xm4 == 0
        +float(one(x))
    else
        -float(one(x))
    end
end

Base.all(::typeof(isinteger), r::AbstractUnitRange{<:HalfInteger}) = !any(!isinteger, r)
Base.all(::typeof(!isinteger), r::AbstractUnitRange{<:HalfInteger}) = !any(isinteger, r)

Base.any(::typeof(isinteger), r::AbstractUnitRange{<:HalfInteger}) =
    !isempty(r) & isinteger(first(r))
Base.any(::typeof(!isinteger), r::AbstractUnitRange{<:HalfInteger}) =
    !isempty(r) & !isinteger(first(r))

"""
    half([T<:HalfInteger,] x)

For an integer value `x`, return `x/2` as a half-integer of type `T`. If `T` is not given,
return an appropriate `HalfInteger` type. Throw an `InexactError` if `x` is not an integer.

# Examples

```jldoctest
julia> half(3)
3/2

julia> half(-5.0)
-5/2

julia> half(HalfInt16, 8)
4
```
"""
half(x::Real) = half(HalfInteger, x)
half(::Type{HalfInteger}, x) = half(HalfInteger, Integer(x))
half(::Type{HalfInteger}, x::Integer) = half(Half{typeof(x)}, x)

"""
    half([T<:Complex{<:HalfInteger},] x)

For a complex value `x` with integer real and imaginary parts, return `x/2` as a complex
number of type `T`. If `T` is not given, return an appropriate complex number type with
half-integer parts. Throw an `InexactError` if the real or the imaginary part of `x` are not
integer.

# Examples

```jldoctest
julia> half(3 + 2im)
3/2 + 1*im

julia> half(Complex{HalfInt32}, 1.0 + 5.0im)
1/2 + 5/2*im
```
"""
half(x::Complex) = half(Complex, x)
half(::Type{Complex{T}}, x) where T<:HalfInteger = Complex(half(T,real(x)), half(T,imag(x)))
half(::Type{Complex}, x) = Complex(half(real(x)), half(imag(x)))

"""
    twice(x)

Return `2x`. If `x` is a `HalfInteger`, return an appropriate integer type.

```jldoctest
julia> twice(2)
4

julia> twice(1.5)
3.0

julia> twice(HalfInt8(3/2))  # returns an Int8
3

julia> twice(HalfInt32(3.0) + HalfInt32(2.5)*im)  # returns a Complex{Int32}
6 + 5im
```
"""
twice(x) = x + x
twice(x::Complex) = Complex(twice(real(x)), twice(imag(x)))

"""
    twice(T<:Integer, x)
    twice(T<:Complex{<:Integer}, x)

Return `2x` as a number of type `T`.

# Examples

```jldoctest
julia> twice(Int16, HalfInt(5/2))
5

julia> twice(Complex{BigInt}, HalfInt(5/2) + HalfInt(3)*im)
5 + 6im
```
"""
twice(T::Type{<:Integer}, x) = T(twice(x))
twice(T::Type{<:Integer}, x::Integer) = twice(T(x)) # convert to T first to reduce probability of overflow
twice(::Type{Complex{T}}, x) where T<:Integer = Complex(twice(T,real(x)), twice(T,imag(x)))

"""
    onehalf(x)

Return the value 1/2 in the type of `x` (`x` can also specify the type itself).

# Examples

```jldoctest
julia> onehalf(7//3)
1//2

julia> onehalf(HalfInt)
1/2
```
"""
onehalf(x::Number) = onehalf(typeof(x))

onehalf(T::Type{<:HalfInteger})     = half(T, 1)
onehalf(T::Type{<:AbstractFloat})   = T(0.5)
onehalf(T::Type{<:Rational})        = T(1//2)
onehalf(::Type{Complex{T}}) where T = Complex(onehalf(T), zero(T))

const HalfIntegerOrInteger = Union{HalfInteger, Integer}

"""
    ishalfinteger(x)

Test whether `x` is numerically equal to some half-integer.

# Examples

```jldoctest
julia> ishalfinteger(3.5)
true

julia> ishalfinteger(2)
true

julia> ishalfinteger(1//3)
false
```
"""
ishalfinteger(x) = isinteger(twice(x))
ishalfinteger(x::Rational) = (denominator(x) == 1) | (denominator(x) == 2)
ishalfinteger(::HalfIntegerOrInteger) = true
ishalfinteger(::AbstractIrrational) = false
ishalfinteger(::Missing) = missing

Base.in(x::Real, r::AbstractUnitRange{<:HalfInteger}) = 
    ishalfinteger(x) & (first(r) ≤ x ≤ last(r)) & !(isinteger(x) ⊻ isinteger(first(r)))

function Base.intersect(r::AbstractUnitRange{<:HalfInteger},
                        s::AbstractUnitRange{<:HalfIntegerOrInteger})
    fir = max(first(r),first(s))
    fir:ifelse(isinteger(first(r)) ⊻ isinteger(first(s)), fir-one(fir), min(last(r),last(s)))
end
Base.intersect(r::AbstractUnitRange{<:Integer}, s::AbstractUnitRange{<:HalfInteger}) = s ∩ r

function Base.intersect(r::Union{AbstractUnitRange{<:HalfInteger}, StepRange{<:HalfInteger}},
                        s::Union{AbstractUnitRange{<:HalfIntegerOrInteger},
                                 StepRange{<:HalfIntegerOrInteger}})
    # All integers are promoted to a common type T to reduce the risk of overflow
    T = promote_type(typeof(twice(first(r))), typeof(twice(step(r))),
                     typeof(twice(first(s))), typeof(twice(step(s))))
    tr = twice(T,first(r)):twice(T,step(r)):twice(T,last(r))
    ts = twice(T,first(s)):twice(T,step(s)):twice(T,last(s))
    trange = tr ∩ ts
    half(first(trange)):half(step(trange)):half(last(trange))
end
Base.intersect(r::Union{AbstractUnitRange{<:Integer}, StepRange{<:Integer}},
               s::Union{AbstractUnitRange{<:HalfInteger}, StepRange{<:HalfInteger}}) = s ∩ r

"""
    Half{T<:Integer} <: HalfInteger

Type for half-integers ``n/2`` where ``n`` is of type `T`.

Aliases for `Half{T}` are defined for all standard `Signed` and `Unsigned` integer types, so
that, e.g., `HalfInt` can be used instead of `Half{Int}`:

| `T`       | Alias for `Half{T}`                |
| :-------- | :--------------------------------- |
| `Int`     | `HalfInt`                          |
| `Int8`    | `HalfInt8`                         |
| `Int16`   | `HalfInt16`                        |
| `Int32`   | `HalfInt32`                        |
| `Int64`   | `HalfInt64`                        |
| `Int128`  | `HalfInt128`                       |
| `BigInt`  | `BigHalfInt` (*not* `HalfBigInt`!) |
| `UInt`    | `HalfUInt`                         |
| `UInt8`   | `HalfUInt8`                        |
| `UInt16`  | `HalfUInt16`                       |
| `UInt32`  | `HalfUInt32`                       |
| `UInt64`  | `HalfUInt64`                       |
| `UInt128` | `HalfUInt128`                      |
"""
struct Half{T<:Integer} <: HalfInteger
    twice::T
    # Inner constructor that is only used to define half(::Type{Half{T}}, x)
    Half{T}(::Val{:inner}, twice) where T<:Integer = new(twice)
end
Half{T}(x::Real) where T<:Integer = half(Half{T}, twice(T,x))
Half{T}(x::Half{T}) where T<:Integer = x

half(::Type{Half{T}}, x) where T<:Integer = Half{T}(Val{:inner}(), x)

twice(x::Half) = x.twice

Base.promote_rule(::Type{Half{H}}, T::Type{<:Real}) where H<:Integer = promote_type(Rational{H}, T)
Base.promote_rule(::Type{Half{H}}, T::Type{<:Integer}) where H<:Integer = Half{promote_type(H, T)}
Base.promote_rule(::Type{Half{T}}, ::Type{Half{S}}) where {T<:Integer,S<:Integer} = Half{promote_type(T,S)}

function Base.parse(T::Type{<:Half}, s::AbstractString)
    result = tryparse(T, s)
    result === nothing && throw(ArgumentError("cannot parse $(repr(s)) as $T."))
    result
end

function Base.tryparse(::Type{Half{T}}, s::AbstractString) where T<:Integer
    matched = match(r"^\s*((?:\+|-|)\s*\d+)\s*(/\s*2|)\s*$", s)
    matched === nothing && return nothing
    num = tryparse(T, matched.captures[1])
    num === nothing && return nothing
    return isempty(matched.captures[2]) ? Half{T}(num) : half(num)
end

Base.typemax(::Type{Half{T}}) where T<:Integer = half(typemax(T))
Base.typemin(::Type{Half{T}}) where T<:Integer = half(typemin(T))

Base.widen(::Type{Half{T}}) where T<:Integer = Half{widen(T)}

const HalfInt = Half{Int}
const HalfInt8 = Half{Int8}
const HalfInt16 = Half{Int16}
const HalfInt32 = Half{Int32}
const HalfInt64 = Half{Int64}
const HalfInt128 = Half{Int128}
const BigHalfInt = Half{BigInt}
const HalfUInt = Half{UInt}
const HalfUInt8 = Half{UInt8}
const HalfUInt16 = Half{UInt16}
const HalfUInt32 = Half{UInt32}
const HalfUInt64 = Half{UInt64}
const HalfUInt128 = Half{UInt128}

Base.sinpi(x::BigHalfInt) = big(invoke(sinpi, Tuple{HalfInteger}, x))
Base.cospi(x::BigHalfInt) = big(invoke(cospi, Tuple{HalfInteger}, x))

end # module
