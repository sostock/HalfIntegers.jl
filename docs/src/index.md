# HalfIntegers.jl

*HalfIntegers.jl* provides data types for half-integer numbers. Here, any number ``\frac{n}{2}`` where ``n\in\mathbb{Z}`` is considered a half-integer -- contrary to the common definition, ``n`` does not have to be odd, i.e., the integers are a subset of the half-integers.

The package defines the abstract `HalfInteger` type and the concrete implementation `Half{T}` for half-integers ``\frac{n}{2}`` where ``n`` is of type `T`.
Functions for convenient use are defined as well.

## Installation

Until HalfIntegers.jl is registered, you can install it by typing
```
add https://github.com/sostock/HalfIntegers.jl
```
in `Pkg` REPL mode.

## Contents

```@contents
Pages = ["manual.md", "api.md"]
```

## Index

```@index
```
