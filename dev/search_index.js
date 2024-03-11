var documenterSearchIndex = {"docs":
[{"location":"api/#API-documentation","page":"API documentation","title":"API documentation","text":"","category":"section"},{"location":"api/","page":"API documentation","title":"API documentation","text":"Modules=[HalfIntegers]","category":"page"},{"location":"api/#Types","page":"API documentation","title":"Types","text":"","category":"section"},{"location":"api/","page":"API documentation","title":"API documentation","text":"Modules=[HalfIntegers]\nOrder=[:type]","category":"page"},{"location":"api/#HalfIntegers.Half","page":"API documentation","title":"HalfIntegers.Half","text":"Half{T<:Integer} <: HalfInteger\n\nType for half-integers n2 where n is of type T.\n\nAliases for Half{T} are defined for all standard Signed and Unsigned integer types, so that, e.g., HalfInt can be used instead of Half{Int}:\n\nT Alias for Half{T}\nInt HalfInt\nInt8 HalfInt8\nInt16 HalfInt16\nInt32 HalfInt32\nInt64 HalfInt64\nInt128 HalfInt128\nBigInt BigHalfInt (not HalfBigInt!)\nUInt HalfUInt\nUInt8 HalfUInt8\nUInt16 HalfUInt16\nUInt32 HalfUInt32\nUInt64 HalfUInt64\nUInt128 HalfUInt128\n\n\n\n\n\n","category":"type"},{"location":"api/#HalfIntegers.HalfInteger","page":"API documentation","title":"HalfIntegers.HalfInteger","text":"HalfInteger <: Real\n\nAbstract supertype for half-integers. Here, every number n2 where ninmathbbZ is considered a half-integer, regardless of whether n is even or odd.\n\n\n\n\n\n","category":"type"},{"location":"api/#Functions","page":"API documentation","title":"Functions","text":"","category":"section"},{"location":"api/","page":"API documentation","title":"API documentation","text":"Modules=[HalfIntegers]\nOrder=[:function]","category":"page"},{"location":"api/#HalfIntegers.checked_twice-Tuple{Any}","page":"API documentation","title":"HalfIntegers.checked_twice","text":"checked_twice(x)\n\nCalculate 2x, checking for overflow. (not exported)\n\ncompat: HalfIntegers 1.4\nThis function requires at least HalfIntegers 1.4.\n\nExamples\n\njulia> x = typemax(Int64)\n9223372036854775807\n\njulia> twice(x)\n-2\n\njulia> HalfIntegers.checked_twice(x)\nERROR: OverflowError: 9223372036854775807 + 9223372036854775807 overflowed for type Int64\nStacktrace:\n[...]\n\n\n\n\n\n","category":"method"},{"location":"api/#HalfIntegers.half-Tuple{Complex}","page":"API documentation","title":"HalfIntegers.half","text":"half([T<:Complex{<:HalfInteger},] x)\n\nFor a complex value x with integer real and imaginary parts, return x/2 as a complex number of type T. If T is not given, return an appropriate complex number type with half-integer parts. Throw an InexactError if the real or the imaginary part of x are not integer.\n\ncompat: HalfIntegers 1.1\nmissing as an argument requires at least HalfIntegers 1.1.\n\nExamples\n\njulia> half(3 + 2im)\n3/2 + 1*im\n\njulia> half(Complex{HalfInt32}, 1.0 + 5.0im)\n1/2 + 5/2*im\n\n\n\n\n\n","category":"method"},{"location":"api/#HalfIntegers.half-Tuple{Real}","page":"API documentation","title":"HalfIntegers.half","text":"half([T<:HalfInteger,] x)\n\nFor an integer value x, return x/2 as a half-integer of type T. If T is not given, return an appropriate HalfInteger type. Throw an InexactError if x is not an integer.\n\ncompat: HalfIntegers 1.1\nmissing as an argument requires at least HalfIntegers 1.1.\n\nExamples\n\njulia> half(3)\n3/2\n\njulia> half(-5.0)\n-5/2\n\njulia> half(HalfInt16, 8)\n4\n\n\n\n\n\n","category":"method"},{"location":"api/#HalfIntegers.ishalfinteger-Tuple{Any}","page":"API documentation","title":"HalfIntegers.ishalfinteger","text":"ishalfinteger(x)\n\nTest whether x is numerically equal to some half-integer.\n\nExamples\n\njulia> ishalfinteger(3.5)\ntrue\n\njulia> ishalfinteger(2)\ntrue\n\njulia> ishalfinteger(1//3)\nfalse\n\n\n\n\n\n","category":"method"},{"location":"api/#HalfIntegers.ishalfodd-Tuple{Number}","page":"API documentation","title":"HalfIntegers.ishalfodd","text":"ishalfodd(x)\n\nTest whether x is numerically equal to some half-odd-integer.\n\nExamples\n\njulia> ishalfodd(3.5)\ntrue\n\njulia> ishalfodd(2)\nfalse\n\njulia> ishalfodd(1//3)\nfalse\n\n\n\n\n\n","category":"method"},{"location":"api/#HalfIntegers.onehalf-Tuple{Union{Missing, Number}}","page":"API documentation","title":"HalfIntegers.onehalf","text":"onehalf(x)\n\nReturn the value 1/2 in the type of x (x can also specify the type itself).\n\ncompat: HalfIntegers 1.1\nmissing as an argument requires at least HalfIntegers 1.1.\n\ncompat: HalfIntegers 1.2\nSome abstract types as arguments require at least HalfIntegers 1.2.\n\nExamples\n\njulia> onehalf(7//3)\n1//2\n\njulia> onehalf(HalfInt)\n1/2\n\n\n\n\n\n","category":"method"},{"location":"api/#HalfIntegers.twice-Tuple{Any}","page":"API documentation","title":"HalfIntegers.twice","text":"twice(x)\n\nReturn 2x. If x is a HalfInteger, return an appropriate integer type.\n\ncompat: HalfIntegers 1.1\nmissing as an argument requires at least HalfIntegers 1.1.\n\nExamples\n\njulia> twice(2)\n4\n\njulia> twice(1.5)\n3.0\n\njulia> twice(HalfInt8(3/2))  # returns an Int8\n3\n\njulia> twice(HalfInt32(3.0) + HalfInt32(2.5)*im)  # returns a Complex{Int32}\n6 + 5im\n\n\n\n\n\n","category":"method"},{"location":"api/#HalfIntegers.twice-Tuple{Type{<:Integer}, Number}","page":"API documentation","title":"HalfIntegers.twice","text":"twice(T<:Integer, x)\ntwice(T<:Complex{<:Integer}, x)\n\nReturn 2x as a number of type T.\n\ncompat: HalfIntegers 1.1\nmissing as an argument requires at least HalfIntegers 1.1.\n\nExamples\n\njulia> twice(Int16, HalfInt(5/2))\n5\n\njulia> twice(Complex{BigInt}, HalfInt(5/2) + HalfInt(3)*im)\n5 + 6im\n\n\n\n\n\n","category":"method"},{"location":"manual/#Manual","page":"Manual","title":"Manual","text":"","category":"section"},{"location":"manual/#Half-integer-types","page":"Manual","title":"Half-integer types","text":"","category":"section"},{"location":"manual/","page":"Manual","title":"Manual","text":"DocTestSetup = quote using HalfIntegers end","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"using HalfIntegers","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"note: Note\nIn this package, any number fracn2 where ninmathbbZ is considered a half-integer – contrary to the common definition, n does not have to be odd, i.e., the integers are a subset of the half-integers.","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"The abstract type HalfInteger <: Real is provided as a supertype for all half-integer types. Concrete half-integer types are provided in the form of the parametric type Half{T} <: HalfInteger where T can be any Integer type. The type Half{T} can represent any number n/2 where n is of type T.","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"Half{Int}(5//2)\nHalf{Int8}(3)\nans isa HalfInteger\ntypemin(Half{Int8}), typemax(Half{Int8})","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"For convenient use, aliases for Half{T} exist for all standard integer types T defined in Julia (except for Bool). For example, HalfInt can be used instead of Half{Int}:","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"HalfInt(3.5)\ntypeof(ans) # Half{Int32} or Half{Int64} depending on on system word size","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"The following aliases are defined:","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"T Alias for Half{T}\nInt HalfInt\nInt8 HalfInt8\nInt16 HalfInt16\nInt32 HalfInt32\nInt64 HalfInt64\nInt128 HalfInt128\nBigInt BigHalfInt (not HalfBigInt!)\nUInt HalfUInt\nUInt8 HalfUInt8\nUInt16 HalfUInt16\nUInt32 HalfUInt32\nUInt64 HalfUInt64\nUInt128 HalfUInt128","category":"page"},{"location":"manual/#Construction-of-HalfIntegers","page":"Manual","title":"Construction of HalfIntegers","text":"","category":"section"},{"location":"manual/","page":"Manual","title":"Manual","text":"HalfIntegers can be created from any other number type using constructors or convert:","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"HalfUInt(5.5)\nconvert(BigHalfInt, 3//2)\nconvert(Complex{HalfInt}, 2.5 + 3.5im)","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"Alternatively, one can use the half function, which halves its argument and returns an appropriate HalfInteger or Complex{<:HalfInteger} type:","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"half(3)\nhalf(4.0)\nhalf(3 - 4im)","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"Note that the argument must be an integer value (or a complex value with integer real and imaginary parts), but does not need to be of an Integer or Complex{<:Integer} type. An optional argument can be used to specify the return type, which must be <:HalfInteger or <:Complex{<:HalfInteger}:","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"half(BigHalfInt, -11)\nhalf(Complex{HalfInt}, 4+1im)","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"Calling the Half constructor without type parameter is disallowed to avoid confusion with the half function.","category":"page"},{"location":"manual/#Conversion","page":"Manual","title":"Conversion","text":"","category":"section"},{"location":"manual/","page":"Manual","title":"Manual","text":"HalfIntegers can be converted to any other number type in the usual ways. When the value is not representable in the new type, an error is thrown:","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"Float32(HalfInt(3/2))\nconvert(Rational{Int}, HalfInt(-5))\nfloat(HalfInt(2))\ncomplex(HalfInt(-1/2))\nconvert(Int, HalfInt(7/2))","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"note: Note\nThe fastest way of converting a HalfInteger to an Integer type is the floor function, since it reduces to a single bit-shift:julia> floor(Integer, HalfInt(5)) # returns an Int\n5Thus, convert(Integer, x) can be replaced by floor(Integer, x) when it is known that x is equal to an integer. This can be useful in performance-critical applications.","category":"page"},{"location":"manual/#Arithmetic-operations","page":"Manual","title":"Arithmetic operations","text":"","category":"section"},{"location":"manual/","page":"Manual","title":"Manual","text":"The provided half-integer types support all common arithmetic operations. For operations between different types, the values are promoted to an appropriate type:","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"HalfInt(1/2) + HalfInt(5)\nHalfInt(1/2) + 5\nHalfInt(1/2) + 5.0\ncomplex(HalfInt(1/2)) + 5//1","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"Since the product of two half-integers is not a half-integer (unless one of them is actually an integer), multiplication of two HalfIntegers results in a floating-point number. Multiplication of a HalfInteger and an Integer yields another HalfInteger:","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"HalfInt(1/2) * HalfInt(7/2)\nHalfInt(1/2) * HalfInt(5)\nHalfInt(1/2) * 5","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"Dividing two half-integers result in a floating-point number as well, but rational and Euclidean division are defined as well:","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"HalfInt(7/2) / HalfInt(3/2)\nHalfInt(7/2) // HalfInt(3/2)\nHalfInt(7/2) ÷ HalfInt(3/2)","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"note: Note\nThe HalfInteger type aims to support every operation that is implemented for Rationals in Base. Some operations are only available in newer Julia versions. For example, gcd for rational numbers is only defined in Julia 1.4 or newer, and is therefore only extended to HalfIntegers in those Julia versions.","category":"page"},{"location":"manual/#Auxiliary-functions","page":"Manual","title":"Auxiliary functions","text":"","category":"section"},{"location":"manual/#twice","page":"Manual","title":"twice","text":"","category":"section"},{"location":"manual/","page":"Manual","title":"Manual","text":"The twice function can be regarded as the inverse of the half function: it doubles its argument. However, in contrast to half, which always returns a HalfInteger or Complex{<:HalfInteger}, twice only returns an Integer when the argument is a HalfInteger or an Integer. Alternatively, the return type of twice can be specified with an optional first argument:","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"twice(HalfInt32(5/2)) # returns an Int32\ntwice(3.5)            # returns a Float64\ntwice(Integer, 3.5)   # returns an Int","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"Furthermore, while half only accepts integer values (or complex values with integer components), the argument of twice may have any numeric value:","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"twice(3//8)\nhalf(ans)","category":"page"},{"location":"manual/#onehalf","page":"Manual","title":"onehalf","text":"","category":"section"},{"location":"manual/","page":"Manual","title":"Manual","text":"Analogous to zero and one, the function onehalf returns the value 1/2 in the specified type (the argument may be a value of the desired type or the type itself):","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"onehalf(HalfInt)\nonehalf(big\"2.0\")\nonehalf(7//3)","category":"page"},{"location":"manual/#ishalfinteger","page":"Manual","title":"ishalfinteger","text":"","category":"section"},{"location":"manual/","page":"Manual","title":"Manual","text":"The function ishalfinteger can be used to check whether a number is equal to some half-integer:","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"ishalfinteger(0.5)\nishalfinteger(4)\nishalfinteger(1//3)","category":"page"},{"location":"manual/#Wraparound-behavior","page":"Manual","title":"Wraparound behavior","text":"","category":"section"},{"location":"manual/","page":"Manual","title":"Manual","text":"Since the implementation of the HalfInteger type is based on the underlying integers (e.g., standard Int arithmetic in the case of the HalfInt type), HalfIntegers may be subject to integer overflow:","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"julia> typemax(HalfInt64)\n9223372036854775807/2\n\njulia> ans + onehalf(HalfInt64)\n-4611686018427387904","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"The behavior in the above example is due to 9223372036854775807 + 1 == -9223372036854775808.","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"Overflows can also occur when converting an Integer to a HalfInteger type (which may happen implicitly due to promotion):","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"julia> typemax(Int64)\n9223372036854775807\n\njulia> HalfInt64(ans)  # 2 * 9223372036854775807 == -2\n-1","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"If you prefer checked arithmetic, you can use functions like Base.checked_add:","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"julia> typemax(HalfInt64)\n9223372036854775807/2\n\njulia> Base.checked_add(ans, onehalf(HalfInt64))\nERROR: OverflowError: 9223372036854775807 + 1 overflowed for type Int64","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"A HalfIntegers.checked_twice function exists as well. Alternatively, you can use the SaferIntegers package:","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"julia> using SaferIntegers\n\njulia> const SafeHalfInt64 = Half{SafeInt64}\nHalf{SafeInt64}\n\njulia> typemax(SafeHalfInt64)\n9223372036854775807/2\n\njulia> ans + onehalf(SafeHalfInt64)\nERROR: OverflowError: 9223372036854775807 + 1 overflowed for type Int64","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"compat: Compat\nUsing Base.checked_add etc. with HalfIntegers requires HalfIntegers ≥ 1.4. The SaferIntegers package can be used with every HalfIntegers version. However, due to a bug, the Half{SafeInt8}, Half{SafeInt16}, Half{SafeUInt8} and Half{SafeUInt16} types require Julia ≥ 1.1 to work correctly.","category":"page"},{"location":"manual/#Custom-HalfInteger-types","page":"Manual","title":"Custom HalfInteger types","text":"","category":"section"},{"location":"manual/","page":"Manual","title":"Manual","text":"To implement a custom type MyHalfInt <: HalfInteger, at least the following methods must be defined:","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"Required method Brief description\nhalf(::Type{MyHalfInt}, x) Return x/2 as a value of type MyHalfInt\ntwice(x::MyHalfInt) Return 2x as a value of some Integer type","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"Thus, a simple implementation of a custom HalfInteger type may look like this:","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"struct MyHalfInt <: HalfInteger\n    val::HalfInt\nend\n\nMyHalfInt(x::MyHalfInt) = x  # to avoid method ambiguity\n\nHalfIntegers.half(::Type{MyHalfInt}, x) = MyHalfInt(half(HalfInt, x))\n\nHalfIntegers.twice(x::MyHalfInt) = twice(x.val)\nnothing # hide","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"The MyHalfInt type supports all arithmetic operations defined for HalfIntegers. However, some operations will return values of a Half{T} type, which may not be desirable:","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"MyHalfInt(3/2) + MyHalfInt(2)\ntypeof(ans)","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"The following sections describe how to customize this behavior.","category":"page"},{"location":"manual/#Customizing-arithmetic-operators-and-functions","page":"Manual","title":"Customizing arithmetic operators and functions","text":"","category":"section"},{"location":"manual/","page":"Manual","title":"Manual","text":"The operators/functions that return a Half{T} type are +, -, mod and rem (and other functions that make use of those, like round). If we want those operations to return MyHalfInts, we can define the following methods (note that both one- and two-argument versions of + and - are defined):","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"Base.:+(x::MyHalfInt) = x\nBase.:+(x::MyHalfInt, y::MyHalfInt) = MyHalfInt(x.val + y.val)\n\nBase.:-(x::MyHalfInt) = MyHalfInt(-x.val)\nBase.:-(x::MyHalfInt, y::MyHalfInt) = MyHalfInt(x.val - y.val)\n\nBase.mod(x::MyHalfInt, y::MyHalfInt) = MyHalfInt(mod(x.val, y.val))\nBase.rem(x::MyHalfInt, y::MyHalfInt) = MyHalfInt(rem(x.val, y.val))\nnothing # hide","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"Now, these arithmetic operations will return a MyHalfInt for MyHalfInt arguments. Certain operations will still yield other types:","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"* and / return floating-point numbers,\ndiv, fld, cld etc. return values of some Integer type.","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"To change this behavior, we would need to define methods for these functions as well. For example, if we want our MyHalfInt type to return a Rational for multiplication and division, we could define the following methods:","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"Base.:*(x::MyHalfInt, y::MyHalfInt) = twice(x)*twice(y)//4\nBase.:/(x::MyHalfInt, y::MyHalfInt) = twice(x)//twice(y)\nnothing # hide","category":"page"},{"location":"manual/#Promotion-rules","page":"Manual","title":"Promotion rules","text":"","category":"section"},{"location":"manual/","page":"Manual","title":"Manual","text":"In order to make mixed-type operations work with our MyHalfInt type, promotion rules need to be defined. As a simple example, we can define our MyHalfInt type to promote like HalfInt as follows:","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"Base.promote_rule(::Type{MyHalfInt}, T::Type{<:Real}) = promote_type(HalfInt, T)\nnothing # hide","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"For more information on how to define promotion rules, cf. the Julia documentation.","category":"page"},{"location":"manual/#Ranges-of-custom-HalfInteger-types","page":"Manual","title":"Ranges of custom HalfInteger types","text":"","category":"section"},{"location":"manual/","page":"Manual","title":"Manual","text":"Ranges of custom HalfInteger types should work if either custom arithmetics or promotion rules are defined. However, intersecting these ranges may again yield ranges of Half{T} values:","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"a = MyHalfInt(3/2):MyHalfInt(3/2):MyHalfInt(15/2)\nb = MyHalfInt(2):MyHalfInt(1):MyHalfInt(9)\nintersect(a, b)\ntypeof(ans)","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"In order to change this behavior, custom methods for Base.intersect need to be defined as well.","category":"page"},{"location":"#HalfIntegers.jl","page":"Home","title":"HalfIntegers.jl","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"HalfIntegers.jl provides data types for half-integer numbers. Here, any number fracn2 where ninmathbbZ is considered a half-integer – contrary to the common definition, n does not have to be odd, i.e., the integers are a subset of the half-integers.","category":"page"},{"location":"","page":"Home","title":"Home","text":"The package defines the abstract HalfInteger type and the concrete implementation Half{T} for half-integers fracn2 where n is of type T. Functions for convenient use are defined as well.","category":"page"},{"location":"#Installation","page":"Home","title":"Installation","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"HalfIntegers.jl is compatible with Julia ≥ 1.0. It can be installed by typing","category":"page"},{"location":"","page":"Home","title":"Home","text":"] add HalfIntegers","category":"page"},{"location":"","page":"Home","title":"Home","text":"in the Julia REPL or via","category":"page"},{"location":"","page":"Home","title":"Home","text":"using Pkg; Pkg.add(\"HalfIntegers\")","category":"page"},{"location":"#Contents","page":"Home","title":"Contents","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Pages = [\"manual.md\", \"api.md\"]","category":"page"},{"location":"#Index","page":"Home","title":"Index","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"","category":"page"}]
}
