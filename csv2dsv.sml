exception emptyInputFile
exception UnevenFields of string

fun convertDelimiters (infilename : string, delim1 : string, outfilename : string, delim2 : string) =
	let
		open TextIO
		val read = openIn(infilename) handle Io => raise emptyInputFile
		val write = openOut(outfilename)
		fun genField(istr : instream, start : bool, double : bool, quotes : bool) : string =
		(*it generates the complete field starting from the current character till the next delimiter
		istr points to just before the start of the first field after the last field*)
			let
				val ch = valOf(input1(istr))
				val m = chr(10)
			in
				if (start andalso ch = #"\"") then
					"\"" ^ genField(istr, false, true, true)
				else if (start andalso ((ord(ch) = 10) orelse (str(ch) = delim1))) then
					"\"" ^ "\"" ^ str(ch)
				else if (start) then
					"\"" ^ str(ch) ^ genField(istr, false, false, false)
				else if ((ord(ch) = 10) orelse (str(ch) = delim1)) then
					if quotes then
						str(ch) ^ genField(istr, false, true, true)
					else if double then
						str(ch)
					else
						"\"" ^ str(ch)
				else if (ch = #"\"") then
					if quotes then
						"\"" ^ genField(istr, false, true, false)
					else
						"\"" ^ genField(istr, false, true, true)
				else if double then
					str(ch) ^ genField(istr, false, true, true)
				else
					if (str(ch) = delim1) then
						delim2 ^ genField(istr, false, false, false)
					else
						str(ch) ^ genField(istr, false, false, false)
			end
		fun genRecord(ch : char, istr : instream, start : bool, count : int) : string =
		(*it generates the complete Record starting from the current element;
		istr points to just before the start of the first field after the last field*)
			if (ord(ch) = 10) then
				str(ch) ^ Int.toString(count)
			else if start then
				let
					val a = genField(istr, true, false, false)
				in
					substring(a, 0, (size(a) - 1)) ^ genRecord(String.sub(a, (size(a) - 1)), istr, false, (count + 1))
				end
			else
				let
					val a = genField(istr, true, false, false)
				in
					delim2 ^ substring(a, 0, (size(a) - 1)) ^ genRecord(String.sub(a, (size(a) - 1)), istr, false, (count + 1))
				end
		fun convert(istr : instream, ostr : outstream, line : int, numFields : int) : unit =
			if (line = 1) then
				if (lookahead(istr) = NONE) then
					raise emptyInputFile
				else
					let
						val record = genRecord(#"1", istr, true, 0)
					in
						output(ostr, substring(record, 0, (size(record) - 1)));
						convert(istr, ostr, 2, valOf(Int.fromString(str(String.sub(record, (size(record) - 1))))))
					end
			else
				if (not (lookahead(istr) = NONE)) then
					let
						val record = genRecord(#"1", istr, true, 0)
					in
						if (valOf(Int.fromString(str(String.sub(record, (size(record) - 1))))) = numFields) then
							(output(ostr, (String.substring(record, 0, (size(record) - 1))));
							convert(istr, ostr, (line + 1), numFields))
						else
							raise UnevenFields("Expected: " ^ Int.toString(numFields) ^ " fields, Present: " ^ str(String.sub(record, (size(record) - 1))) ^ " fields on Line " ^ Int.toString(line) ^ "\n")
					end
				else ()
	in
		convert(read, write, 1, 0);
		closeIn(read);
		closeOut(write)
 	end

fun csv2tsv(infilename : string, outfilename : string) = convertDelimiters (infilename, ",", outfilename, "\t");

fun tsv2csv(infilename : string, outfilename : string) = convertDelimiters (infilename, "\t", outfilename, ",");