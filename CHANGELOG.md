# HalfIntegers.jl changelog

## v1.2.1

* ![Enhancement][badge-enhancement] Add specialized `round(::Type{<:Integer}, ::HalfInteger, ::typeof(RoundDown))` method for better performance. (#16)

## v1.2.0

* ![Feature][badge-feature] `onehalf` now accepts abstract types as argument. (#14)
* ![Enhancement][badge-enhancement] Add custom `sincospi` method (only on Julia ≥ 1.6). (#10)
* ![Bugfix][badge-bugfix] `onehalf(Complex{T})` now actually returns a `Complex{T}` when `T` is an abstract type. (#14)

## v1.1.2

* ![Bugfix][badge-bugfix] Resolve method ambiguities with `Base`. (#9)

## v1.1.1

* ![Enhancement][badge-enhancement] Performance improvements for `Rational`s on Julia ≥ 1.5. (#7)

## v1.1.0

* ![Feature][badge-feature] Add support for `Missing`.

## v1.0.0

First stable release.
