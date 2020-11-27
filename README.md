# HalfIntegers

[![PkgEval](https://juliaci.github.io/NanosoldierReports/pkgeval_badges/H/HalfIntegers.svg)](https://juliaci.github.io/NanosoldierReports/pkgeval_badges/report.html)
[![CI](https://github.com/sostock/HalfIntegers.jl/workflows/CI/badge.svg)](https://github.com/sostock/HalfIntegers.jl/actions?query=workflow%3ACI)
[![codecov](https://codecov.io/gh/sostock/HalfIntegers.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/sostock/HalfIntegers.jl)

[![](https://img.shields.io/badge/docs-stable-blue.svg)](https://sostock.github.io/HalfIntegers.jl/stable)
[![](https://img.shields.io/badge/docs-dev-blue.svg)](https://sostock.github.io/HalfIntegers.jl/dev)

**If you are using version 0.1 of this package, it is highly recommended that you upgrade to version 1. It is backwards compatible except for removing support for Julia 0.7.**

This package provides data types for half-integer numbers. Here, any number *n*/2 where *n*
is an integer is considered a half-integer – contrary to the
[common definition](https://en.wikipedia.org/wiki/Half-integer),
*n* does not have to be odd, i.e., the integers are a subset of the half-integers.

For example, the `HalfInt` type provided by this package can be used to represent numbers
*n*/2 where *n* is an `Int`. Likewise, there exist half-integer types for all of Julia’s
signed and unsigned integer types, e.g., `HalfInt8`, `HalfUInt128`, and `BigHalfInt` for
arbitrarily large half-integers. All half-integer types are subtypes of the abstract type
`HalfInteger`.

## Installation

HalfIntegers.jl is compatible with Julia ≥ 1.0.
It can be installed by typing
```
] add HalfIntegers
```
in the Julia REPL or via
```julia
using Pkg; Pkg.add("HalfIntegers")
```

## Basic usage

`HalfInteger`s can be created from any other number type by using constructors or `convert`:

```julia
julia> HalfInt(-2.5)
-5/2

julia> convert(HalfUInt16, 7//2)
7/2

julia> BigHalfInt(2)
2
```

Another way of creating an `HalfInteger` is the `half` function:

```julia
julia> half(11)
11/2

julia> half(HalfInt8, -3)
-3/2
```

`HalfInteger` types support all standard arithmetic operations. Furthermore, this package
defines the function `twice`. For any number *x*, the function `twice` returns the number
2*x*. For `HalfInteger` types, it returns an `Integer` type.

```julia
julia> twice(1.5)
3.0

julia> twice(HalfInt64(1.5))
3

julia> typeof(ans)
Int64
```

## The `Half{T<:Integer}` type

All concrete half-integer types provided by this package are actually just aliases for
`Half{T}` with a specific `T`:

```julia
julia> typeof(HalfInt64(1/2))
Half{Int64}
```

The type `Half{T}` accepts arbitrary `<:Integer` types as parameter. It can be used to
define half-integers based on other (non-standard) integers. For example, since `HalfInt`
etc. are based on standard integer arithmetic, they are subject to
[integer overflow](https://docs.julialang.org/en/v1/manual/integers-and-floating-point-numbers/#Overflow-behavior-1).
If you prefer checked arithmetic, you can use the
[SaferIntegers](https://github.com/JeffreySarnoff/SaferIntegers.jl)
package and use `Half{SafeInt}` instead of `HalfInt`.

## Alternatives to this package

- [FixedPointNumbers.jl](https://github.com/JuliaMath/FixedPointNumbers.jl) implements
  numbers with a fixed number of fraction bits. Thus, the `Fixed{Int,1}` type from
  `FixedPointNumbers` can be considered equivalent to the `HalfInt` type from this package.
  However, the types behave differently in some ways. For example, multiplying two
  `Fixed{T,f}` numbers results in another `Fixed{T,f}` number, whereas multiplying two
  `HalfInteger`s results in a floating-point number.
