# HalfIntegers.jl changelog

## master

## v1.3.0

* ![Feature](https://img.shields.io/badge/-feature-green) `ispow2` accepts `HalfInteger` arguments on Julia ≥ 1.6. ([#26](https://github.com/sostock/HalfIntegers.jl/pull/26))

## v1.2.4

* ![Maintenance](https://img.shields.io/badge/-maintenance-grey) Fix tests on Julia ≥ 1.6. ([#25](https://github.com/sostock/HalfIntegers.jl/pull/25))

## v1.2.3

* ![Maintenance](https://img.shields.io/badge/-maintenance-grey) Fix tests on Julia ≥ 1.6. ([#23](https://github.com/sostock/HalfIntegers.jl/pull/23))

## v1.2.2

* ![Enhancement](https://img.shields.io/badge/-enhancement-blue) Added a specialized `float(::Type{BigHalfInt})` method for better performance. ([#21](https://github.com/sostock/HalfIntegers.jl/pull/21))
* ![Enhancement](https://img.shields.io/badge/-enhancement-blue) Added specialized `sinc` and `cosc` methods for better performance. ([#22](https://github.com/sostock/HalfIntegers.jl/pull/22))

## v1.2.1

* ![Enhancement](https://img.shields.io/badge/-enhancement-blue) Added a specialized `round(::Type{<:Integer}, ::HalfInteger, ::typeof(RoundDown))` method for better performance. ([#16](https://github.com/sostock/HalfIntegers.jl/pull/16))

## v1.2.0

* ![Feature](https://img.shields.io/badge/-feature-green) `onehalf` now accepts abstract types as argument. ([#14](https://github.com/sostock/HalfIntegers.jl/pull/14))
* ![Enhancement](https://img.shields.io/badge/-enhancement-blue) Added a specialized `sincospi` method on Julia ≥ 1.6. ([#10](https://github.com/sostock/HalfIntegers.jl/pull/10))
* ![Bugfix](https://img.shields.io/badge/-bugfix-purple) `onehalf(Complex{T})` now actually returns a `Complex{T}` when `T` is an abstract type. ([#14](https://github.com/sostock/HalfIntegers.jl/pull/14))

## v1.1.2

* ![Bugfix](https://img.shields.io/badge/-bugfix-purple) Resolved method ambiguities with `Base`. ([#9](https://github.com/sostock/HalfIntegers.jl/pull/9))

## v1.1.1

* ![Enhancement](https://img.shields.io/badge/-enhancement-blue) Performance improvements for `Rational`s on Julia ≥ 1.5. ([#7](https://github.com/sostock/HalfIntegers.jl/pull/7))

## v1.1.0

* ![Feature](https://img.shields.io/badge/-feature-green) `half`, `onehalf`, and `twice` now support `Missing`.

## v1.0.0

First stable release.
