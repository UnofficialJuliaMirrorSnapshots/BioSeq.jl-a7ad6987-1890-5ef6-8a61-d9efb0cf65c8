BioSeq
=========

Package for working with Biological Sequences and Alignments on Julia

-----------------------------------------

Types:

	BioUnit

Abstract type for creation of Biological Units of 8-bit

	Nucleotide

8-bit bits type for Nucleotides (ribo-and deoxyribonucleic acids) as a subtype for BioUnit.
Vectors of Nucleotides can be used as DNA or RNA Sequences and Matrices as Alignments

	Nucleotide8bit

Immutable type in development wrapping an `Uint8` for faster test over nucleotides sequences.
The Bit-Level Coding Scheme is described on: [ Paradis, Emmanuel. "A Bit-Level Coding Scheme for Nucleotides." (2007). ](http://ape.mpl.ird.fr/misc/BitLevelCodingScheme_20April2007.pdf)

	AminoAcid

8-bit bits type for Amino Acids as a subtype of BioUnit
Vectors of Amino Acids can be used as Protein Sequences and Matrices as Alignments

	Nucleotide2bitSeq
	Nucleotide2bitBase

`Nucleotide2bitSeq` is for nucleotide sequence of 2 bits, only for A C T/U G.
Slice with `Int` return a `Nucleotide2bitBase` immutable type
Contains 2 `BitVector` named `b1` and `b2`:

b1\b2 | false | true 
--------|--------|-------
**false** |   A   |  C
**true**  |   T   |  G


String-like behavior for BioUnit Arrays
-----------------------------------------

	lowercase{T<:BioUnit}(x::T)
	lowercase!{T<:BioUnit}(s::AbstractArray{T})
	lowercase{T<:BioUnit}(s::AbstractArray{T})

Conversion of BioUnit and BioUnit Arrays to lowercase

	uppercase{T<:BioUnit}(x::T)
	uppercase!{T<:BioUnit}(s::AbstractArray{T})
	uppercase{T<:BioUnit}(s::AbstractArray{T})

Conversion of BioUnit and BioUnit Arrays to uppercase

	repeat{T<:BioUnit}(s::Vector{T}, n::Int)

Repeat n times an BioUnit Vector

	repeat{T<:BioUnit}(x::T, n::Int)

Repeat BioUnit for generate an BioUnit Vector

AminoAcid
----------

	aminoacid(x)
	aminoacid(vec::Vector)
	aminoacid(str::ASCIIString)
	aminoacid(mat::Matrix)

Converts to Nucleotide or Nucleotide Array
AminoAcid Vector for Protein Sequence and Matrix for Alignments

	@aa_str

Creates a AminoAcid Vector (Protein Sequence) using aa" ... " (but string interpolation is only supported for Julia 0.1)


Nucleotide
----------

	nucleotide(x)
	nucleotide(vec::Vector)
	nucleotide(str::ASCIIString)
	nucleotide(mat::Matrix)
	nucleotide(seq::Nucleotide2bitSeq)

Converts to Nucleotide or Nucleotide Array
Nucleotide Vector for DNA or RNA Sequence and Matrix for Alignments

	@nt_str

Creates a Nucleotide Vector (DNA or RNA Sequence) using nt" ... " (but string interpolation is only supported for Julia 0.1)

	dna2rna!(x)
	dna2rna(x)
	rna2dna!(x)
	rna2dna(x)

All this functions interchange between T and U and are case insensitive. If you know your sequence is all uppercase or all lowercase, `swap!(seq,'T','U')` or `swap!(seq,'t','u')` are faster choices.

	complement!(x,d)
	complement(x,d)
	reversecomplement!(x,d)
	reversecomplement(x,d)

This functions give us the complement sequence or the reverse complement. d can be `RNA_COMPLEMENT` or `DNA_COMPLEMENT` or a user defined Array indexed with Nucleotides keys.

Nucleotide2bitSeq
-----------------

	Nucleotide2bitSeq(len::Int)

Initialize a Nucleotide2bitSeq with Thymines of length len

	nucleotide2bit(x)

Converts to `Nucleotide2bitSeq` or `Nucleotide2bitBase`

	@nt2_str

Creates a 2-bit Nucleotide sequence using nt2" ... " (but string interpolation is only supported for Julia 0.1)

	nucleotide(seq::Nucleotide2bitSeq)

Converts from Nucleotide2bitSeq to Nucleotide Vector

	complement!(seq::Nucleotide2bitSeq)
	complement(seq::Nucleotide2bitSeq)
	reversecomplement!(seq::Nucleotide2bitSeq)
	reversecomplement(seq::Nucleotide2bitSeq)

This functions give us the complement sequence or the reverse complement for a 2-bit Nucleotide sequence.

	percentGC(seq::Nucleotide2bitSeq)

Fastest GC content estimation for 2-bit Nucleotide sequence

	isadenine(seq::Nucleotide2bit)
	iscytosine(seq::Nucleotide2bit)
	isthymine(seq::Nucleotide2bit)
	isguanine(seq::Nucleotide2bit)
	isweak(seq::Nucleotide2bit)
	isstrong(seq::Nucleotide2bit)
	ispyrimidine(seq::Nucleotide2bit)
	ispurine(seq::Nucleotide2bit)

Faster vectorized functions for test A, C, T, G, AT, CG, CT and AG respectively

Nucleotide8bit
-----------------

	nucleotide8bit(x)

Converts to Nucleotide8bit

	@nt8_str

Creates a 8-bit Bit-Level Coding Scheme Nucleotide sequence using nt8" ... " (but string interpolation is only supported for Julia 0.1)

	percentGC(seq::Nucleotide8bit)

Fastest GC content estimation for 2-bit Nucleotide sequence

	isadenine
	iscytosine
	isthymine
	isguanine
	ispyrimidine
	ispurine

Faster vectorized functions for test A, C, T, G, CT and AG respectively

Matching on BioUnit Vectors
----------------------------

The next functions works as in String but on BioUnit Vectors:

	ismatch{T<:BioUnit}(r::Regex, s::Vector{T})
	match{T<:BioUnit}(re::Regex, s::Vector{T}, idx::Integer)
	match{T<:BioUnit}(r::Regex, s::Vector{T})
	search{T<:BioUnit}(s::Vector{T}, r::Regex, idx::Integer)
	search{T<:BioUnit}(s::Vector{T}, r::Regex)
	search{T<:BioUnit}(s::Vector{T}, c, i::Integer)
	search{T<:BioUnit}(s::Vector{T}, c)
	eachmatch{T<:BioUnit}(re::Regex, s::Vector{T}, ovr::Bool)
	eachmatch{T<:BioUnit}(re::Regex, s::Vector{T})
	replace{T<:BioUnit}(s::Vector{T}, pattern, r, limit::Integer)
	replace{T<:BioUnit}(s::Vector{T}, pat, r)

Swap between BioUnits on Arrays
---------------------------------

	swap!{T<:BioUnit,Tp<:Integer,Tc<:Integer}(x::AbstractArray{T},p::Tp,c::Tc)
	swap{T<:BioUnit,Tp<:Integer,Tc<:Integer}(x::AbstractArray{T},p::Tp,c::Tc)

Interchange a character for other


IUPAC REGEX
-----------

	@aar_str

Creates a IUPAC regex for amino acids using `aar"..."`. For example, `ismatch(@aar_str("AWJ"),aminoacid("AWI"))` returns `true`.

	@ntr_str

Creates a IUPAC regex for nucleotides using `ntr"..."`. For example, `ismatch(@ntr_str("ABN"),nucleotide("ATC"))` returns `true`.

PROSITE PATTERN REGEX
---------------------

	@prosite_str

Creates a regex from a PROSITE pattern as described [here](http://prosite.expasy.org/scanprosite/scanprosite-doc.html#pattern_syntax) for amino acids using `prosite"..."`



Functions for Alphabets
-----------------------

`Alphabet` is an especializated type for Alphabets of `AminoAcid` or `Nucleotide`
Can be created using the `alphabet` function:

	alphabet{T<:BioUnit}(seq::Vector{T},case_sensitive::Bool)

For example, the aminolookup's alphabet of Octave and MATLAB can be created as:

	aminolookup = alphabet(aa"ARNDCQEGHILKMFPSTWYVBZX*-",false)

Depend on tyour needs, you can create an alphabet as an IntSet, Set or Dict too.
Look at the end for Alphabets defined on on BioSeq.jl

	isin{T}(s::AbstractArray{T},y::Union(IntSet,Set,Associative))

Test for characters on an alphabet (`in`in previous version)

	check{T}(s::AbstractArray{T},y::Union(IntSet,Set,Associative))

Check for characters on an alphabet  (returns `Bool`)

	swap{T,Tk,Tv}(s::AbstractArray{T},y::Dict{Tk,Tv})
	swap!{T<:Number}(s::AbstractArray{T},y::Dict{T,T})

Interchange a character for other on a Dict

	swap{T,Tk,Tv}(s::AbstractArray{T},y::Array)
	swap!{T<:Number}(s::AbstractArray{T},y::Array)

Interchange a character for other on a Array (keys must be the indexes)

Translation
-----------

	CODON_TABLES

Contains codons tables from [ NCBI Genetic Codes ](http://www.ncbi.nlm.nih.gov/Taxonomy/Utils/wprintgc.cgi)
Tables are stored as two matrices (`amino` and `start`).
Each genetic code is a column. The `ids` field can be used for mapping table ids to column number.
Each codon is a row. Codons can be mapped to row number using the `codons` field.

	codon2aa(codon,tableid)

Gives the amino acid represented for the codon given an table id.

	isstop(tableid)
	isstart(tableid)

For a table id returns a `BitArray`. Codon to index can be mapped with the `Dict` `CODON_TABLES.codons`

	isstop(seq,tableid)
	isstart(seq,tableid)

Returns a Bool (codon) or BitArray (sequence)

	translate(seq,tableid)
	translatetostop(seq,tableid)
	translateCDS(seq,tableid)

`translate` change codons to amino acid given a table id.
`translatetostop` change codons to amino acid given a table id until and stop is founded.
`translateCDS` change codons to amino acid given a table id only if the sequence length is multiple of three and starts with a start codon and ends with a stop codon.

Nucleotide Alphabets
--------------------

	NUCLEIC_IUPAC
	DNA_COMPLEMENT
	RNA_COMPLEMENT
	NUCLEIC_IUPAC_AMBIGUOUS_DICT

Protein Alphabets
-----------------

	AMINO_IUPAC
	AMINO_20_UPPERCASE
	AMINO_1LETTER_TO_3
	AMINO_3LETTERS_TO_1
	AMINO_IUPAC_EXTENDED_DICT
