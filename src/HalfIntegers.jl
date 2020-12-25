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
HalfInteger(x::Integer) = Half{typeof(x)}(x)
HalfInteger(x::HalfInteger) = x
HalfInteger(x::Rational{T}) where T = Half{T}(x)
HalfInteger(x::BigFloat) = BigHalfInt(x)

(T::Type{<:AbstractFloat})(x::HalfInteger) = T(float(x))
(T::Type{<:Integer})(x::HalfInteger) =
    isinteger(x) ? T(twice(x) >> 1) : throw(InexactError(Symbol(T), T, x))
(::Type{Bool})(x::HalfInteger) = invoke(Bool, Tuple{Real}, x)
@static if VERSION ≥ v"1.5.0-DEV.820"
    function (::Type{Rational})(x::HalfInteger)
        tx = twice(x)
        if isinteger(x)
            Base.unsafe_rational(tx >> 1, one(tx))
        else
            Base.unsafe_rational(tx, oftype(tx, 2))
        end
    end
    function (::Type{Rational{T}})(x::HalfInteger) where T
        tx = twice(x)
        if isinteger(x)
            Base.unsafe_rational(T, tx >> 1, one(tx))
        else
            Base.unsafe_rational(T, tx, oftype(tx,2))
        end
    end
else
    (T::Type{<:Rational})(x::HalfInteger) = (tx=twice(x); T(tx,oftype(tx,2)))
end

Base.ArithmeticStyle(::Type{<:HalfInteger}) = Base.ArithmeticWraps()

for op in (:<, :≤, :(==))
    @eval Base.$op(x::HalfInteger, y::HalfInteger) = $op(twice(x), twice(y))
    @eval Base.$op(x::HalfInteger, y::Integer) = ((pt,py)=promote(twice(x),y); $op(pt, twice(py)))
    @eval Base.$op(x::Integer, y::HalfInteger) = ((px,pt)=promote(x,twice(y)); $op(twice(px), pt))
    @eval Base.$op(x::HalfInteger, y::Rational) = $op(twice(x)*denominator(y), twice(numerator(y)))
    @eval Base.$op(x::Rational, y::HalfInteger) = $op(twice(numerator(x)), twice(y)*denominator(x))
end

Base.:+(x::T, y::T) where T<:HalfInteger = half(twice(x)+twice(y))
Base.:+(x::HalfInteger) = half(+twice(x))
Base.:-(x::T, y::T) where T<:HalfInteger = half(twice(x)-twice(y))
Base.:-(x::HalfInteger) = half(-twice(x))

Base.:*(x::T, y::T) where T<:HalfInteger = float(x)*float(y)
Base.:*(x::HalfInteger, y::Integer) = half(twice(x)*y)
Base.:*(x::Integer, y::HalfInteger) = y*x

Base.:/(x::T, y::T) where T<:HalfInteger = twice(x)/twice(y)

Base.://(x::HalfInteger, y::HalfInteger) = twice(x)//twice(y)
Base.://(x::HalfInteger, y::Real) = twice(x)//twice(y)
Base.://(x::Real, y::HalfInteger) = twice(x)//twice(y)

Base.:^(x::Real, y::HalfInteger) = x^float(y)
Base.:^(::Irrational{:ℯ}, x::HalfInteger) = exp(x)

@static if VERSION < v"1.4.0-DEV.208"
    Base.div(x::T, y::T) where T<:HalfInteger = div(twice(x), twice(y))
else
    Base.div(x::T, y::T, r::RoundingMode) where T<:HalfInteger = div(twice(x), twice(y), r)
end
Base.fld(x::T, y::T) where T<:HalfInteger = fld(twice(x), twice(y)) # can be removed in Julia 2.0
Base.cld(x::T, y::T) where T<:HalfInteger = cld(twice(x), twice(y)) # can be removed in Julia 2.0
Base.rem(x::T, y::T) where T<:HalfInteger = half(rem(twice(x), twice(y)))
Base.mod(x::T, y::T) where T<:HalfInteger = half(mod(twice(x), twice(y)))

Base.fld1(x::T, y::T) where T<:HalfInteger = fld1(twice(x), twice(y))

# `lcm`/`gcd`/`gcdx` are only extended to `HalfInteger`s if they are defined for `Rational`s
@static if VERSION ≥ v"1.4.0-DEV.699"
    Base.gcd(x::HalfInteger) = x
    Base.lcm(x::HalfInteger) = x

    Base.gcd(a::T, b::T) where T<:HalfInteger = half(gcd(twice(a), twice(b)))
    Base.lcm(a::T, b::T) where T<:HalfInteger = half(lcm(twice(a), twice(b)))

    function Base.gcdx(x::T, y::T) where T<:HalfInteger
        d, u, v = gcdx(twice(x), twice(y))
        half(d), u, v
    end
end

Base.ceil(T::Type{<:Integer}, x::HalfInteger)  = round(T, x, RoundUp)
Base.floor(T::Type{<:Integer}, x::HalfInteger) = round(T, x, RoundDown)
Base.trunc(T::Type{<:Integer}, x::HalfInteger) = round(T, x, RoundToZero)

Base.round(T::Type{<:Integer}, x::HalfInteger, r::RoundingMode=RoundNearest) =
    T(twice(round(x, r)) >> 1)
Base.round(T::Type{<:Integer}, x::HalfInteger, ::typeof(RoundDown)) = T(twice(x) >> 1)

Base.round(x::HalfInteger, ::typeof(RoundNearest)) =
    isinteger(x)             ? +x           :
    isone(mod1(twice(x), 4)) ? x-onehalf(x) : x+onehalf(x)
Base.round(x::HalfInteger, ::typeof(RoundNearestTiesAway)) =
    isinteger(x) ? +x           :
    x < zero(x)  ? x-onehalf(x) : x+onehalf(x)
Base.round(x::HalfInteger, ::typeof(RoundNearestTiesUp)) =
    isinteger(x) ? +x : x+onehalf(x)
Base.round(x::HalfInteger, ::typeof(RoundToZero)) =
    isinteger(x) ? +x           :
    x < zero(x)  ? x+onehalf(x) : x-onehalf(x)
Base.round(x::HalfInteger, ::typeof(RoundUp)) =
    round(x, RoundNearestTiesUp)
Base.round(x::HalfInteger, ::typeof(RoundDown)) =
    isinteger(x) ? +x : x-onehalf(x)

Base.big(x::HalfInteger) = BigHalfInt(x)

Base.float(x::HalfInteger) = twice(x)/2

Base.isfinite(x::HalfInteger) = isfinite(twice(x))

Base.isinteger(x::HalfInteger) = iseven(twice(x))

@static if VERSION ≥ v"1.6.0-DEV.999"
    Base.ispow2(x::HalfInteger) = ispow2(twice(x))
end

Base.show(io::IO, x::HalfInteger) =
    isinteger(x) ? print(io, twice(x) >> 1) : print(io, twice(x), "/2")

Base.sign(x::HalfInteger) = oftype(x, sign(twice(x)))

Base.denominator(x::HalfInteger) = (t=twice(x); isinteger(x) ? one(t) : oftype(t,2))
Base.numerator(x::HalfInteger)   = (t=twice(x); isinteger(x) ? t >> 1 : t)

Base.sinpi(x::HalfInteger) = sinpihalf(twice(x))
Base.cospi(x::HalfInteger) = cospihalf(twice(x))

Base.sinc(x::HalfInteger) = sinchalf(twice(x))
Base.cosc(x::HalfInteger) = coschalf(twice(x))

# Compute sin(x*π/2)
function sinpihalf(x::Integer)
    xm4 = mod(x,4)
    T = float(typeof(x))
    if (xm4 == 0) | (xm4 == 2)
        x < 0 ? -zero(T) : +zero(T)
    elseif xm4 == 1
        +one(T)
    else
        -one(T)
    end
end
# Compute cos(x*π/2)
function cospihalf(x::Integer)
    xm4 = mod(x,4)
    T = float(typeof(x))
    if (xm4 == 1) | (xm4 == 3)
        +zero(T)
    elseif xm4 == 0
        +one(T)
    else
        -one(T)
    end
end

# Compute sinc(x/2)
function sinchalf(x::Integer)
    iszero(x) && return one(float(typeof(x)))
    iseven(x) && return zero(float(typeof(x)))
    d = inv(π*x)
    isone(mod(x % Int8, Int8(4))) ? 2*d : -2*d
end
# Compute cosc(x/2)
function coschalf(x::Integer)
    T = float(typeof(x))
    iszero(x) && return zero(T)
    xm4 = mod(x % Int8, Int8(4))
    x⁻¹ = inv(x)
    if xm4 == 0
        2*x⁻¹
    elseif xm4 == 1
        (-4/T(π))*x⁻¹*x⁻¹
    elseif xm4 == 2
        -2*x⁻¹
    else
        (4/T(π))*x⁻¹*x⁻¹
    end
end

@static if VERSION ≥ v"1.6.0-DEV.292"
    Base.sincospi(x::HalfInteger) = sincospihalf(twice(x))

    # Compute sincos(x*π/2)
    function sincospihalf(x::Integer)
        xm4 = mod(x,4)
        T = float(typeof(x))
        if xm4 == 0
            (x < 0 ? -zero(T) : +zero(T), +one(T))
        elseif xm4 == 1
            (+one(T), +zero(T))
        elseif xm4 == 2
            (x < 0 ? -zero(T) : +zero(T), -one(T))
        else
            (-one(T), +zero(T))
        end
    end
end

Base.all(::typeof(isinteger), r::AbstractUnitRange{<:HalfInteger}) = !any(!isinteger, r)
Base.all(::typeof(!isinteger), r::AbstractUnitRange{<:HalfInteger}) = !any(isinteger, r)

Base.any(::typeof(isinteger), r::AbstractUnitRange{<:HalfInteger}) =
    !isempty(r) & isinteger(first(r))
Base.any(::typeof(!isinteger), r::AbstractUnitRange{<:HalfInteger}) =
    !isempty(r) & !isinteger(first(r))


# Hashing


Base.decompose(x::HalfInteger) = twice(x), 0, 2

Base.hash(x::HalfInteger, h::UInt) = hashhalf(twice(x), h)

# Compute hash(half(x), h)
hashhalf(x::Integer, h::UInt) = invoke(hash, Tuple{Real,UInt}, half(x), h)

# Version for integers with ≤ 64 bits, adapted from hash(::Rational{<:Base.BitInteger64}, ::UInt)
function hashhalf(x::Base.BitInteger64, h::UInt)
    iseven(x) && return hash(x >> 1, h)
    if abs(x) < 9007199254740992
        return hash(ldexp(Float64(x),-1),h)
    end
    h = Base.hash_integer(1, h)
    h = Base.hash_integer(-1, h)
    h = Base.hash_integer(x, h)
    return h
end


"""
    half([T<:HalfInteger,] x)

For an integer value `x`, return `x/2` as a half-integer of type `T`. If `T` is not given,
return an appropriate `HalfInteger` type. Throw an `InexactError` if `x` is not an integer.

!!! compat "HalfIntegers 1.1"
    `missing` as an argument requires at least HalfIntegers 1.1.

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
half(::Type{HalfInteger}, x::Number) = half(HalfInteger, Integer(x))
half(::Type{HalfInteger}, x::Integer) = half(Half{typeof(x)}, x)

"""
    half([T<:Complex{<:HalfInteger},] x)

For a complex value `x` with integer real and imaginary parts, return `x/2` as a complex
number of type `T`. If `T` is not given, return an appropriate complex number type with
half-integer parts. Throw an `InexactError` if the real or the imaginary part of `x` are not
integer.

!!! compat "HalfIntegers 1.1"
    `missing` as an argument requires at least HalfIntegers 1.1.

# Examples

```jldoctest
julia> half(3 + 2im)
3/2 + 1*im

julia> half(Complex{HalfInt32}, 1.0 + 5.0im)
1/2 + 5/2*im
```
"""
half(x::Complex) = half(Complex, x)
half(::Type{Complex{T}}, x::Number) where T<:HalfInteger = Complex(half(T,real(x)), half(T,imag(x)))
half(::Type{Complex}, x::Number) = Complex(half(real(x)), half(imag(x)))

half(::Missing) = missing
@static if VERSION ≥ v"1.3"
    half(::Type{T}, x) where T>:Missing = half(Base.nonmissingtype_checked(T), x)
else
    half(::Type{T}, x) where T>:Missing = half(Base.nonmissingtype(T), x)
end
half(::Type{>:Missing}, ::Missing) = missing
half(::Type{T}, ::Missing) where T =
    throw(MissingException("cannot convert a missing value to type $T: use Union{$T, Missing} instead"))


"""
    twice(x)

Return `2x`. If `x` is a `HalfInteger`, return an appropriate integer type.

!!! compat "HalfIntegers 1.1"
    `missing` as an argument requires at least HalfIntegers 1.1.

# Examples

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

!!! compat "HalfIntegers 1.1"
    `missing` as an argument requires at least HalfIntegers 1.1.

# Examples

```jldoctest
julia> twice(Int16, HalfInt(5/2))
5

julia> twice(Complex{BigInt}, HalfInt(5/2) + HalfInt(3)*im)
5 + 6im
```
"""
twice(T::Type{<:Integer}, x::Number) = T(twice(x))
twice(T::Type{<:Integer}, x::Integer) = twice(T(x)) # convert to T first to reduce probability of overflow
twice(::Type{Complex{T}}, x::Number) where T<:Integer = Complex(twice(T,real(x)), twice(T,imag(x)))

@static if VERSION ≥ v"1.3"
    twice(::Type{T}, x) where T>:Missing = twice(Base.nonmissingtype_checked(T), x)
else
    twice(::Type{T}, x) where T>:Missing = twice(Base.nonmissingtype(T), x)
end
twice(::Type{>:Missing}, ::Missing) = missing
twice(::Type{T}, ::Missing) where T =
    throw(MissingException("cannot convert a missing value to type $T: use Union{$T, Missing} instead"))

"""
    onehalf(x)

Return the value 1/2 in the type of `x` (`x` can also specify the type itself).

!!! compat "HalfIntegers 1.1"
    `missing` as an argument requires at least HalfIntegers 1.1.

!!! compat "HalfIntegers 1.2"
    Some abstract types as arguments require at least HalfIntegers 1.2.

# Examples

```jldoctest
julia> onehalf(7//3)
1//2

julia> onehalf(HalfInt)
1/2
```
"""
onehalf(x::Union{Number,Missing}) = onehalf(typeof(x))

onehalf(T::Type{<:Number}) = T(onehalf(HalfInteger))
onehalf(T::Type{<:HalfInteger}) = half(T, 1)
onehalf(T::Type{<:AbstractFloat}) = T(0.5)
@static if VERSION ≥ v"1.5.0-DEV.820"
    onehalf(::Type{Rational}) = Base.unsafe_rational(1, 2)
    onehalf(::Type{Rational{T}}) where T = Base.unsafe_rational(T, 1, 2)
else
    onehalf(T::Type{<:Rational}) = T(1, 2)
end
onehalf(::Type{Complex{T}}) where T = Complex{T}(onehalf(T), zero(T))
onehalf(::Type{Missing}) = missing

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

Base._range(start::T, ::Nothing, stop::T, len::Integer) where T<:HalfInteger =
    Base._linspace(float(T), start, stop, len)

Base._linspace(::Type{T}, start::HalfInteger, stop::HalfInteger, len::Integer) where T =
    LinRange{T}(start, stop, len)
Base._linspace(::Type{T}, start::HalfInteger, stop::HalfInteger, len::Integer) where T<:Base.IEEEFloat =
    Base._linspace(T, twice(start), twice(stop), len, 2)

Base.in(x::Real, r::AbstractUnitRange{<:HalfInteger}) = 
    ishalfinteger(x) & (first(r) ≤ x ≤ last(r)) & !(isinteger(x) ⊻ isinteger(first(r)))

function Base.intersect(r::AbstractUnitRange{<:HalfInteger},
                        s::AbstractUnitRange{<:HalfIntegerOrInteger})
    fir = max(first(r),first(s))
    las = min(last(r), last(s))
    las = isinteger(first(r)) ⊻ isinteger(first(s)) ? oftype(las, fir-one(fir)) : las
    fir:las
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

half(::Type{Half{T}}, x::Number) where T<:Integer = Half{T}(Val{:inner}(), x)

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

Base.float(::Type{BigHalfInt}) = BigFloat

end # module
