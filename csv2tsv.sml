fun convertDelimiters (infilename : string, delim1 : string, outfilename : string, delim2 : string) =
	let
		open TextIO
		val read = openIn(infilename)
		val write = openOut(outfilename)
		fun checker(ch : char, istr : instream, ostr : outstream) =
			if (ord(ch) = 10) then print(str(ch)) else ()
		fun readChar(ch : char option, istr : instream, ostr : outstream) : unit =
			case ch of
				NONE => () |
				SOME(c) => (checker(valOf(ch), istr, ostr); readChar(input1(istr), istr, ostr))
	in
		readChar(input1(read), read, write)
	end

fun csv2tsv(infilename : string, outfilename : string) = convertDelimiters (infilename, ",", outfilename, "\t");

fun tsv2csv(infilename : string, outfilename : string) = convertDelimiters (infilename, "\t", outfilename, ",");

(*fun convertNewlines (infilename : string, newline1 : string, outfilename : string, newline2 : string) = 0;

fun unix2dos(infilename : string, outfilename : string) = 0;

fun dos2unix(infilename : string, outfilename : string) = 0;*)

csv2tsv("a.txt", "b.txt");