## Show & convert as Nucleotide ##

const _to_bitscheme = zeros(UInt8,256)
_to_bitscheme[Int('A')] = 136
_to_bitscheme[Int('G')] = 72
_to_bitscheme[Int('C')] = 40
_to_bitscheme[Int('T')] = 24
_to_bitscheme[Int('U')] = 24
_to_bitscheme[Int('R')] = 192
_to_bitscheme[Int('M')] = 160
_to_bitscheme[Int('W')] = 144
_to_bitscheme[Int('S')] = 96
_to_bitscheme[Int('K')] = 80
_to_bitscheme[Int('Y')] = 48
_to_bitscheme[Int('V')] = 224
_to_bitscheme[Int('H')] = 176
_to_bitscheme[Int('D')] = 208
_to_bitscheme[Int('B')] = 112
_to_bitscheme[Int('N')] = 240
_to_bitscheme[Int('X')] = 240
_to_bitscheme[Int('-')] = 4
_to_bitscheme[Int('.')] = 4
_to_bitscheme[Int('?')] = 2
_to_bitscheme[Int('a')] = 136
_to_bitscheme[Int('g')] = 72
_to_bitscheme[Int('c')] = 40
_to_bitscheme[Int('t')] = 24
_to_bitscheme[Int('u')] = 24
_to_bitscheme[Int('r')] = 192
_to_bitscheme[Int('m')] = 160
_to_bitscheme[Int('w')] = 144
_to_bitscheme[Int('s')] = 96
_to_bitscheme[Int('k')] = 80
_to_bitscheme[Int('y')] = 48
_to_bitscheme[Int('v')] = 224
_to_bitscheme[Int('h')] = 176
_to_bitscheme[Int('d')] = 208
_to_bitscheme[Int('b')] = 112
_to_bitscheme[Int('n')] = 240
_to_bitscheme[Int('x')] = 240

const _to_uint8 = zeros(UInt8,256)
_to_uint8[136] = 'A'
_to_uint8[72] = 'G'
_to_uint8[40] = 'C'
_to_uint8[24] = 'T'
_to_uint8[192] = 'R'
_to_uint8[160] = 'M'
_to_uint8[144] = 'W'
_to_uint8[96] = 'S'
_to_uint8[80] = 'K'
_to_uint8[48] = 'Y'
_to_uint8[224] = 'V'
_to_uint8[176] = 'H'
_to_uint8[208] = 'D'
_to_uint8[112] = 'B'
_to_uint8[240] = 'N'
_to_uint8[4] = '-'
_to_uint8[2] = '?'

# Must be immutable
immutable Nucleotide8bit
  byte::UInt8
  Nucleotide8bit{T<:Union{Integer, Char}}(x::T) = new(_to_bitscheme[x])
end

## Conversions ##
# All conversions change the bit representation

convert{T<:Union{Integer, Char}}(::Type{Nucleotide8bit},x::T) = Nucleotide8bit(x)
convert{T<:Union{Integer, Char}}(::Type{T},x::Nucleotide8bit) = convert(T,_to_uint8[x.byte])
convert(::Type{UInt8},x::Nucleotide8bit) = _to_uint8[x.byte]

nucleotide(base::Nucleotide8bit) =  _to_uint8[base.byte]

nucleotide8bit{T<:Union{Integer, Char}}(value::T)   = convert(Nucleotide8bit,value)

nucleotide8bit{T<:Union{Integer, Char}}(vec::Vector{T})  = convert(Vector{Nucleotide8bit},vec)
nucleotide8bit{T<:Union{Integer, Char}}(mat::Matrix{T})  = convert(Matrix{Nucleotide8bit},mat)

nucleotide8bit(str::ASCIIString)  = convert(Vector{Nucleotide8bit},str)

bytestring(seq::Vector{Nucleotide8bit}) = bytestring(convert(Vector{UInt8},seq))

macro nt8_str(s);  :(convert(Vector{Nucleotide8bit}, @b_str($s) )); end

convert(::Type{ASCIIString}, seq::Vector{Nucleotide8bit}) = ASCIIString(convert(Vector{UInt8},seq))
convert(::Type{Vector{Nucleotide8bit}}, str::ASCIIString) = convert(Vector{Nucleotide8bit},str.data)

## Show ##

show(io::IO,x::Nucleotide8bit) = (write(io,_to_uint8[x.byte]); nothing)

## Bits representation ##

bits(x::Nucleotide8bit) = bits(x.byte)

## Comparisons ##
# By conversions to an Integer type

for fun in [:(==),:(!=),:(<),:(<=)]
  @eval $(fun){T<:Union{Integer, Char}}(x::Nucleotide8bit,y::T) = $(fun)(convert(T,x),y)
  @eval $(fun){T<:Union{Integer, Char}}(x::T,y::Nucleotide8bit) = $(fun)(x,convert(T,y))
end

## Bitwise Operations ##
# Using the byte field
# return Integer

~(x::Nucleotide8bit)              = ~x.byte

for fun in [:((&)),:(|),:(($))]
  @eval $(fun){T<:Union{Integer, Char}}(x::Nucleotide8bit,y::T) = $(fun)(x.byte,y)
  @eval $(fun){T<:Union{Integer, Char}}(x::T,y::Nucleotide8bit) = $(fun)(x,y.byte)
  @eval $(fun)(x::Nucleotide8bit,y::Nucleotide8bit) = $(fun)(x.byte,y.byte)
end

for fun in [:(<<),:(>>),:((>>>))]
  @eval $(fun)(x::Nucleotide8bit,y::Int32) = $(fun)(x.byte,y)
end

## mmap doesn't work

mmap_array{N}(::Type{Nucleotide8bit},dims::NTuple{N,Int64},s::IO,offset::Int64) = throw("Not implemented for Nucleotide8bit")

## Faster methods using the Bit Level Scheme

## 136
isadenine(base::Nucleotide8bit) = base.byte == 136
function isadenine{T<:AbstractArray{Nucleotide8bit}}(s::T)
  res = BitArray(size(s))
  for i in 1:length(s)
    res[i] = s[i].byte == 136
  end
  res
end
## 72
isguanine(base::Nucleotide8bit) = base.byte == 72
function isguanine{T<:AbstractArray{Nucleotide8bit}}(s::T)
  res = BitArray(size(s))
  for i in 1:length(s)
    res[i] = s[i].byte == 72
  end
  res
end
## 40
iscytosine(base::Nucleotide8bit)= base.byte == 40
function iscytosine{T<:AbstractArray{Nucleotide8bit}}(s::T)
  res = BitArray(size(s))
  for i in 1:length(s)
    res[i] = s[i].byte == 40
  end
  res
end
## 24
isthymine(base::Nucleotide8bit) = base.byte == 24
function isthymine{T<:AbstractArray{Nucleotide8bit}}(s::T)
  res = BitArray(size(s))
  for i in 1:length(s)
    res[i] = s[i].byte == 24
  end
  res
end
## & 55 == 0
ispurine(base::Nucleotide8bit)  = base & 55 == 0
function ispurine{T<:AbstractArray{Nucleotide8bit}}(s::T)
  res = BitArray(size(s))
  for i in 1:length(s)
    res[i] = s[i] & 55 == 0
  end
  res
end
## & 199 == 0
ispyrimidine(base::Nucleotide8bit) = base & 199 == 0
function ispyrimidine{T<:AbstractArray{Nucleotide8bit}}(s::T)
  res = BitArray(size(s))
  for i in 1:length(s)
    res[i] = s[i] & 199 == 0
  end
  res
end
## & 8 == 8 if a is known surely
isknown(base::Nucleotide8bit) = base & 8 == 8
function isknown{T<:AbstractArray{Nucleotide8bit}}(s::T)
  res = BitArray(size(s))
  for i in 1:length(s)
    res[i] = s[i] & 8 == 8
  end
  res
end

## (a & b) < 16 if a and b are different surely
!=(x::Nucleotide8bit,y::Nucleotide8bit) = x & y < 16
## isknown(a) && a == b if a and b are the same surely
==(x::Nucleotide8bit,y::Nucleotide8bit) = (x & 8 == 8) && (x.byte == y.byte)

function percentGC(seq::Vector{Nucleotide8bit})
  len = length(seq)
  sum = 0
  for elem in seq
    if elem.byte == 40 || elem.byte == 72 || elem.byte == 96
      sum += 1
    end
  end
  sum/len
end

# Hash as Nucleotide
hash(base::Nucleotide8bit) = hash(nucleotide(base))

==(S1::Nucleotide8bit, S2::Nucleotide8bit) = ==(S1.byte,S2.byte)

# Julia 0.2 compatibility
isequal(S1::Nucleotide8bit, S2::Nucleotide8bit) = isequal(S1.byte,S2.byte)

const _convert_to_nt8 = Nucleotide8bit[UInt8('A') UInt8('C');UInt8('T') UInt8('G')]

function convert(::Type{Nucleotide2bitBase},s::Nucleotide8bit)
  _convert_to_base2[s & 7]
end
function convert(::Type{Nucleotide8bit},s::Nucleotide2bitBase)
  _convert_to_nt8[s.b1+1,s.b2+1]
end

==(S1::Nucleotide8bit, S2::Nucleotide2bit) = ==(convert(T,S1),S2)
==(S1::Nucleotide2bit, S2::Nucleotide8bit) = ==(S1,convert(T,S2))

# Julia 0.2 compatibility
isequal{T<:Union{Integer,Nucleotide2bit}}(S1::Nucleotide8bit, S2::T) = isequal(convert(T,S1),S2)
isequal{T<:Union{Integer,Nucleotide2bit}}(S1::T, S2::Nucleotide8bit) = isequal(S1,convert(T,S2))

# Hash Vector{Nucleotide8bit} as Vector{Nucleotide}
hash(seq::Vector{Nucleotide8bit}) = hash(nucleotide(seq))

==(S1::Vector{Nucleotide8bit}, S2::Vector{Nucleotide}) = ==(nucleotide(S1),S2)
==(S1::Vector{Nucleotide}, S2::Vector{Nucleotide8bit}) = ==(S1,nucleotide(S2))

# Julia 0.2 compatibility
isequal(S1::Vector{Nucleotide8bit}, S2::Vector{Nucleotide}) = isequal(nucleotide(S1),S2)
isequal(S1::Vector{Nucleotide}, S2::Vector{Nucleotide8bit}) = isequal(S1,nucleotide(S2))
