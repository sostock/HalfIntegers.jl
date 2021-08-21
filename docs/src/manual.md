# Manual

## Half-integer types

```@meta
DocTestSetup = quote using HalfIntegers end
```
```@setup halfintegers
using HalfIntegers
```

!!! note
    In this package, any number ``\frac{n}{2}`` where ``n\in\mathbb{Z}`` is considered a half-integer -- contrary to the common definition, ``n`` does not have to be odd, i.e., the integers are a subset of the half-integers.

The abstract type `HalfInteger <: Real` is provided as a supertype for all half-integer types.
Concrete half-integer types are provided in the form of the parametric type `Half{T} <: HalfInteger` where `T` can be any `Integer` type.
The type `Half{T}` can represent any number `n/2` where `n` is of type `T`.

```@repl halfintegers
Half{Int}(5//2)
Half{Int8}(3)
ans isa HalfInteger
typemin(Half{Int8}), typemax(Half{Int8})
```

For convenient use, aliases for `Half{T}` exist for all standard integer types `T` defined in Julia (except for `Bool`).
For example, `HalfInt` can be used instead of `Half{Int}`:

```@repl halfintegers
HalfInt(3.5)
typeof(ans) # Half{Int32} or Half{Int64} depending on on system word size
```

The following aliases are defined:

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

## Construction of `HalfInteger`s

`HalfInteger`s can be created from any other number type using constructors or `convert`:

```@repl halfintegers
HalfUInt(5.5)
convert(BigHalfInt, 3//2)
convert(Complex{HalfInt}, 2.5 + 3.5im)
```

Alternatively, one can use the `half` function, which halves its argument and returns an appropriate `HalfInteger` or `Complex{<:HalfInteger}` type:

```@repl halfintegers
half(3)
half(4.0)
half(3 - 4im)
```

Note that the argument must be an integer value (or a complex value with integer real and imaginary parts), but does not need to be of an `Integer` or `Complex{<:Integer}` type.
An optional argument can be used to specify the return type, which must be `<:HalfInteger` or `<:Complex{<:HalfInteger}`:

```@repl halfintegers
half(BigHalfInt, -11)
half(Complex{HalfInt}, 4+1im)
```

Calling the `Half` constructor without type parameter is disallowed to avoid confusion with the `half` function.

## Conversion

`HalfInteger`s can be converted to any other number type in the usual ways. When the value is not representable in the new type, an error is thrown:
```@repl halfintegers
Float32(HalfInt(3/2))
convert(Rational{Int}, HalfInt(-5))
float(HalfInt(2))
complex(HalfInt(-1/2))
convert(Int, HalfInt(7/2))
```

!!! note
    The fastest way of converting a `HalfInteger` to an `Integer` type is the `floor` function, since it reduces to a single bit-shift:
    ```@repl halfintegers
    julia> floor(Integer, HalfInt(5)) # returns an Int
    5
    ```
    Thus, `convert(Integer, x)` can be replaced by `floor(Integer, x)` when it is known that `x` is equal to an integer. This can be useful in performance-critical applications.

## Arithmetic operations

The provided half-integer types support all common arithmetic operations.
For operations between different types, the values are promoted to an appropriate type:

```@repl halfintegers
HalfInt(1/2) + HalfInt(5)
HalfInt(1/2) + 5
HalfInt(1/2) + 5.0
complex(HalfInt(1/2)) + 5//1
```

Since the product of two half-integers is not a half-integer (unless one of them is actually an integer), multiplication of two `HalfInteger`s results in a floating-point number.
Multiplication of a `HalfInteger` and an `Integer` yields another `HalfInteger`:

```@repl halfintegers
HalfInt(1/2) * HalfInt(7/2)
HalfInt(1/2) * HalfInt(5)
HalfInt(1/2) * 5
```

Dividing two half-integers result in a floating-point number as well, but rational and Euclidean division are defined as well:

```@repl halfintegers
HalfInt(7/2) / HalfInt(3/2)
HalfInt(7/2) // HalfInt(3/2)
HalfInt(7/2) ÷ HalfInt(3/2)
```

!!! note
    The `HalfInteger` type aims to support every operation that is implemented for `Rational`s in `Base`.
    Some operations are only available in newer Julia versions.
    For example, `gcd` for rational numbers is only defined in Julia 1.4 or newer, and is therefore only extended to `HalfInteger`s in those Julia versions.

## Auxiliary functions

### `twice`

The `twice` function can be regarded as the inverse of the `half` function: it doubles its argument.
However, in contrast to `half`, which always returns a `HalfInteger` or `Complex{<:HalfInteger}`, `twice` only returns an `Integer` when the argument is a `HalfInteger` or an `Integer`.
Alternatively, the return type of `twice` can be specified with an optional first argument:

```@repl halfintegers
twice(HalfInt32(5/2)) # returns an Int32
twice(3.5)            # returns a Float64
twice(Integer, 3.5)   # returns an Int
```

Furthermore, while `half` only accepts integer values (or complex values with integer components), the argument of `twice` may have any numeric value:

```@repl halfintegers
twice(3//8)
half(ans)
```

### `onehalf`

Analogous to `zero` and `one`, the function `onehalf` returns the value 1/2 in the specified type (the argument may be a value of the desired type or the type itself):

```@repl halfintegers
onehalf(HalfInt)
onehalf(big"2.0")
onehalf(7//3)
```

### `ishalfinteger`

The function `ishalfinteger` can be used to check whether a number is equal to some half-integer:

```@repl halfintegers
ishalfinteger(0.5)
ishalfinteger(4)
ishalfinteger(1//3)
```

## Wraparound behavior

Since the implementation of the `HalfInteger` type is based on the underlying integers (e.g., standard `Int` arithmetic in the case of the `HalfInt` type), `HalfInteger`s may be subject to [integer overflow](https://docs.julialang.org/en/v1/manual/integers-and-floating-point-numbers/#Overflow-behavior-1):

```jldoctest
julia> typemax(HalfInt64)
9223372036854775807/2

julia> ans + onehalf(HalfInt64)
-4611686018427387904
```

The behavior in the above example is due to `9223372036854775807 + 1 == -9223372036854775808`.

Overflows can also occur when converting an `Integer` to a `HalfInteger` type (which may happen implicitly due to promotion):

```jldoctest
julia> typemax(Int64)
9223372036854775807

julia> HalfInt64(ans)  # 2 * 9223372036854775807 == -2
-1
```

If you prefer checked arithmetic, you can use functions like `Base.checked_add`:

```jldoctest
julia> typemax(HalfInt64)
9223372036854775807/2

julia> Base.checked_add(ans, onehalf(HalfInt64))
ERROR: OverflowError: 9223372036854775807 + 1 overflowed for type Int64
```

A `HalfIntegers.checked_twice` function exists as well.
Alternatively, you can use the [SaferIntegers](https://github.com/JeffreySarnoff/SaferIntegers.jl) package:

```jldoctest
julia> using SaferIntegers

julia> const SafeHalfInt64 = Half{SafeInt64}
Half{SafeInt64}

julia> typemax(SafeHalfInt64)
9223372036854775807/2

julia> ans + onehalf(SafeHalfInt64)
ERROR: OverflowError: 9223372036854775807 + 1 overflowed for type Int64
```

!!! compat
    Using `Base.checked_add` etc. with `HalfInteger`s requires HalfIntegers ≥ 1.4.
    The SaferIntegers package can be used with every HalfIntegers version.
    However, due to a [bug](https://github.com/JuliaLang/julia/issues/32203), the `Half{SafeInt8}`, `Half{SafeInt16}`, `Half{SafeUInt8}` and `Half{SafeUInt16}` types require Julia ≥ 1.1 to work correctly.

## Custom `HalfInteger` types

To implement a custom type `MyHalfInt <: HalfInteger`, at least the following methods must be defined:

| Required method | Brief description |
| :-------------- | :---------------- |
| `half(::Type{MyHalfInt}, x)` | Return `x/2` as a value of type `MyHalfInt` |
| `twice(x::MyHalfInt)`        | Return `2x` as a value of some `Integer` type |

Thus, a simple implementation of a custom `HalfInteger` type may look like this:

```@example halfintegers
struct MyHalfInt <: HalfInteger
    val::HalfInt
end

MyHalfInt(x::MyHalfInt) = x  # to avoid method ambiguity

HalfIntegers.half(::Type{MyHalfInt}, x) = MyHalfInt(half(HalfInt, x))

HalfIntegers.twice(x::MyHalfInt) = twice(x.val)
nothing # hide
```

The `MyHalfInt` type supports all arithmetic operations defined for `HalfInteger`s. However, some operations will return values of a `Half{T}` type, which may not be desirable:

```@repl halfintegers
MyHalfInt(3/2) + MyHalfInt(2)
typeof(ans)
```

The following sections describe how to customize this behavior.

### Customizing arithmetic operators and functions

The operators/functions that return a `Half{T}` type are `+`, `-`, `mod` and `rem` (and other functions that make use of those, like `round`).
If we want those operations to return `MyHalfInt`s, we can define the following methods (note that both one- and two-argument versions of `+` and `-` are defined):

```@example halfintegers
Base.:+(x::MyHalfInt) = x
Base.:+(x::MyHalfInt, y::MyHalfInt) = MyHalfInt(x.val + y.val)

Base.:-(x::MyHalfInt) = MyHalfInt(-x.val)
Base.:-(x::MyHalfInt, y::MyHalfInt) = MyHalfInt(x.val - y.val)

Base.mod(x::MyHalfInt, y::MyHalfInt) = MyHalfInt(mod(x.val, y.val))
Base.rem(x::MyHalfInt, y::MyHalfInt) = MyHalfInt(rem(x.val, y.val))
nothing # hide
```

Now, these arithmetic operations will return a `MyHalfInt` for `MyHalfInt` arguments.
Certain operations will still yield other types:
* `*` and `/` return floating-point numbers,
* `div`, `fld`, `cld` etc. return values of some `Integer` type.
To change this behavior, we would need to define methods for these functions as well.
For example, if we want our `MyHalfInt` type to return a `Rational` for multiplication and division, we could define the following methods:

```@example halfintegers
Base.:*(x::MyHalfInt, y::MyHalfInt) = twice(x)*twice(y)//4
Base.:/(x::MyHalfInt, y::MyHalfInt) = twice(x)//twice(y)
nothing # hide
```

### Promotion rules

In order to make mixed-type operations work with our `MyHalfInt` type, promotion rules need to be defined.
As a simple example, we can define our `MyHalfInt` type to promote like `HalfInt` as follows:

```@example halfintegers
Base.promote_rule(::Type{MyHalfInt}, T::Type{<:Real}) = promote_type(HalfInt, T)
nothing # hide
```

For more information on how to define promotion rules, cf. the
[Julia documentation](https://docs.julialang.org/en/v1/manual/conversion-and-promotion/#Promotion-1).

### Ranges of custom `HalfInteger` types

Ranges of custom `HalfInteger` types should work if either custom arithmetics or promotion rules are defined.
However, intersecting these ranges may again yield ranges of `Half{T}` values:

```@repl halfintegers
a = MyHalfInt(3/2):MyHalfInt(3/2):MyHalfInt(15/2)
b = MyHalfInt(2):MyHalfInt(1):MyHalfInt(9)
intersect(a, b)
typeof(ans)
```

In order to change this behavior, custom methods for `Base.intersect` need to be defined as well.
